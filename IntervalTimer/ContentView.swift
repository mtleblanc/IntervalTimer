import SwiftUI

struct ContentView: View {
    @State private var sequences: [TimerSequence] = loadSequences()
    @State private var selectedSequenceForEditing: TimerSequence?
    @State private var selectedSequenceForRunning: TimerSequence?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sequences) { sequence in
                    Button(action: {
                        self.selectedSequenceForRunning = sequence
                    }) {
                        HStack {
                            Text(sequence.name)
                            Spacer()
                        }
                    }
                    .contentShape(Rectangle()) // Ensures the entire row is tappable
                    .swipeActions(edge: .trailing) {
                        Button(action: {
                            self.selectedSequenceForEditing = sequence
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                        
                        Button(role: .destructive) {
                            if let index = sequences.firstIndex(where: { $0.id == sequence.id }) {
                                sequences.remove(at: index)
                                saveSequences(sequences)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
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
                    self.selectedSequenceForEditing = newSequence
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(item: $selectedSequenceForEditing) { sequence in
                SequenceEditorView(sequence: sequence, onSave: { updatedSequence in
                    if let index = self.sequences.firstIndex(where: { $0.id == updatedSequence.id }) {
                        self.sequences[index] = updatedSequence
                    }
                    saveSequences(self.sequences)
                    self.selectedSequenceForEditing = nil
                })
            }
            .sheet(item: $selectedSequenceForRunning) { sequence in
                TimerExecutionView(sequence: sequence)
            }
        }
    }
}
