//
//  IntervalTimerApp.swift
//  IntervalTimer
//
//  Created by Michael LeBlanc on 2024-06-09.
//

import SwiftUI
import AVFoundation

@main
struct IntervalTimerApp: App {
    init() {
        configureAudioSession()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category. \(error)")
        }
    }
}
