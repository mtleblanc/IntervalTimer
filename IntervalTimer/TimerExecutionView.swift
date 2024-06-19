import SwiftUI
import AVFoundation
import Combine

struct TimerExecutionView: View {
    let sequence: TimerSequence
    @State private var currentStepIndex = 0
    @State private var remainingTime: TimeInterval = 0
    @State private var stepEndTime: CFTimeInterval!
    @State private var stepStartTime: CFTimeInterval!
    @State private var timer: AnyCancellable?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isRunning: Bool = false
    
    var body: some View {
        VStack {
            if currentStepIndex < sequence.steps.count {
                Text(sequence.steps[currentStepIndex].name)
                    .font(.largeTitle)
                Text("\(remainingTime, specifier: "%.1f") seconds remaining")
                    .font(.title)
                Button(action: startOrPause) {
                    Text(timer == nil ? "Start" : "Pause")
                        .font(.title)
                }
            } else {
                Text("Sequence Complete")
                    .font(.largeTitle)
            }
        }
        .onAppear {
            preloadSound()
            startNextStep()
            UIApplication.shared.isIdleTimerDisabled = true
            LocationManager.shared.update = updateTimer
        }
        .onDisappear {
            LocationManager.shared.update = nil
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
    
    func startNextStep() {
        guard currentStepIndex < sequence.steps.count else {
            stopTimer()
            // Sequence finished
            return
        }
        remainingTime = sequence.steps[currentStepIndex].duration
        stepStartTime = CACurrentMediaTime()
        stepEndTime = CACurrentMediaTime() + remainingTime
    }
    func updateTimer() {
        if(self.isRunning) {
            self.remainingTime = stepEndTime - CACurrentMediaTime()
            if self.remainingTime <= 0 {
                print("Took \(CACurrentMediaTime() - stepStartTime)")
                self.playSound()
                self.currentStepIndex += 1
                self.startNextStep()
            }
        }
    }
    
    func startTimer() {
        stepEndTime = CACurrentMediaTime() + remainingTime
        isRunning = true
        print("Expecting to end at \(stepEndTime!)")
        timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect().sink { _ in
            updateTimer()
        }
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
        isRunning = false
    }
    
    func startOrPause() {
        if timer == nil {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    func preloadSound() {
        guard let soundURL = Bundle.main.url(forResource: "ding-126626", withExtension: "mp3") else {
            print("Sound file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
    
    func playSound() {
        audioPlayer?.play()
    }
}
