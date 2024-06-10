import SwiftUI

struct TimerExecutionView: View {
    var sequence: TimerSequence
    @State private var currentStepIndex = 0
    @State private var remainingTime: TimeInterval = 0
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            Text(sequence.steps[currentStepIndex].name)
                .font(.largeTitle)
            Text("\(remainingTime, specifier: "%.1f") seconds remaining")
                .font(.title)
            Button(action: startOrPause) {
                Text(timer == nil ? "Start" : "Pause")
                    .font(.title)
            }
        }
        .onAppear(perform: startNextStep)
        .onDisappear(perform: stopTimer)
    }
    
    func startNextStep() {
        guard currentStepIndex < sequence.steps.count else {
            // Sequence finished
            return
        }
        remainingTime = sequence.steps[currentStepIndex].duration
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.remainingTime -= 1
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
    
    func playSound() {
        // Play sound code here
    }
}
