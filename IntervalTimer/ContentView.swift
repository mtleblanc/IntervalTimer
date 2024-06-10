import SwiftUI

struct ContentView: View {
    @State private var sequences: [TimerSequence] = loadSequences()
    @State private var selectedSequence: TimerSequence?
    @State private var isEditing: Bool = false
    @State private var isRunning: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sequences) { sequence in
                    HStack {
                        Text(sequence.name)
                        Spacer()
                        Button(action: {
                            self.selectedSequence = sequence
                            self.isRunning = true
                        }) {
                            Text("Run")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            self.selectedSequence = sequence
                            self.isEditing = true
                        }) {
                            Image(systemName: "pencil")
                        }
                        .buttonStyle(BorderlessButtonStyle())
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
                    self.isEditing = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $isEditing) {
                if let sequence = selectedSequence {
                    SequenceEditorView(sequence: sequence, onSave: { updatedSequence in
                        if let index = self.sequences.firstIndex(where: { $0.id == updatedSequence.id }) {
                            self.sequences[index] = updatedSequence
                        }
                        saveSequences(self.sequences)
                        self.isEditing = false
                        self.selectedSequence = nil
                    })
                }
            }
            .sheet(isPresented: $isRunning) {
                if let sequence = selectedSequence {
                    TimerExecutionView(sequence: sequence)
                }
            }
        }
    }
}
