import SwiftUI
import AVFoundation

struct TimerView: View {
    let durations: [Double] = [Double](arrayLiteral: 5,5,10) // Array of durations in seconds
    @State private var currentTimerIndex = 0
    @State private var timeRemaining: Double
    var player: AVAudioPlayer?

    init() {
        self._timeRemaining = State(initialValue: durations.first ?? 0)
        do {
            let soundURL = Bundle.main.url(forResource: "ding-126626", withExtension: "mp3")!
            player = try AVAudioPlayer(contentsOf: soundURL)
            player?.prepareToPlay()
        } catch {
            print("Error loading sound")
        }
    }

    var body: some View {
        Text("Time Remaining: \(timeRemaining)")
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    player?.play()
                    moveToNextTimer()
                }
            }
    }
    
    private func moveToNextTimer() {
        if currentTimerIndex < durations.count - 1 {
            currentTimerIndex += 1
            timeRemaining = durations[currentTimerIndex]
        } else {
            // Finish sequence or loop
            currentTimerIndex = 0
            timeRemaining = durations.first ?? 0
        }
    }
}

