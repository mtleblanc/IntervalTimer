import Foundation
import CoreLocation
import AVFoundation

struct TimerStep: Identifiable, Codable {
    var id = UUID()
    var name: String
    var duration: TimeInterval // duration in seconds
    public func clone() -> Self {
        TimerStep(name: name, duration: duration)
    }
}

struct TimerSequence: Identifiable, Codable {
    var id = UUID()
    var name: String
    var steps: [TimerStep]
    public func clone() -> Self {
        TimerSequence(name: name, steps: steps.map{ $0.clone() })
    }
}

func saveSequences(_ sequences: [TimerSequence]) {
    if let encoded = try? JSONEncoder().encode(sequences) {
        UserDefaults.standard.set(encoded, forKey: "sequences")
    }
}

func loadSequences() -> [TimerSequence] {
    if let savedData = UserDefaults.standard.data(forKey: "sequences"),
       let decoded = try? JSONDecoder().decode([TimerSequence].self, from: savedData) {
        return decoded
    }
    return []
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    public static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    var update: (() -> Void)? = nil
    override init() {
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization() // or use requestWhenInUseAuthorization() based on your need
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        update?()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
