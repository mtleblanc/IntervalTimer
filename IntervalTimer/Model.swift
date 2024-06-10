import Foundation

struct TimerStep: Identifiable, Codable {
    var id = UUID()
    var name: String
    var duration: TimeInterval // duration in seconds
}

struct TimerSequence: Identifiable, Codable {
    var id = UUID()
    var name: String
    var steps: [TimerStep]
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
