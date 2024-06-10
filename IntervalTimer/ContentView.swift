import SwiftUI

struct ContentView: View {
    @State private var sequences: [TimerSequence] = loadSequences()
    @State private var selectedSequence: TimerSequence?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sequences) { sequence in
                    Button(action: {
                        self.selectedSequence = sequence
                    }) {
                        Text(sequence.name)
                    }
                }
                .onDelete { indexSet in
                    self.sequences.remove(atOffsets: indexSet)
                    saveSequences(self.sequences)
                }
            }
            .navigationTitle("Timer Sequences")
            .navigationBarItems(trailing:
                Button(action: {
                    let newSequence = TimerSequence(name: "New Sequence", steps: [])
                    self.sequences.append(newSequence)
                    self.selectedSequence = newSequence
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(item: $selectedSequence) { sequence in
                SequenceEditorView(sequence: sequence, onSave: { updatedSequence in
                    if let index = self.sequences.firstIndex(where: { $0.id == updatedSequence.id }) {
                        self.sequences[index] = updatedSequence
                    }
                    saveSequences(self.sequences)
                    self.selectedSequence = nil // Dismiss the sheet
                })
            }
        }
    }
}
