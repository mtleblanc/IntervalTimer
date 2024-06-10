import SwiftUI
import AVFoundation

struct TimerExecutionView: View {
    var sequence: TimerSequence
    @State private var currentStepIndex = 0
    @State private var remainingTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var audioPlayer: AVAudioPlayer?
    
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
        }
        .onDisappear(perform: stopTimer)
    }
    
    func startNextStep() {
        guard currentStepIndex < sequence.steps.count else {
            stopTimer()
            // Sequence finished
            return
        }
        remainingTime = sequence.steps[currentStepIndex].duration
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.remainingTime -= 0.1
            if self.remainingTime <= 0 {
                self.playSound()
                self.currentStepIndex += 1
                self.startNextStep()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
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
