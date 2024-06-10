import SwiftUI

struct SequenceEditorView: View {
    @State var sequence: TimerSequence
    var onSave: (TimerSequence) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sequence Name")) {
                    TextField("Name", text: $sequence.name)
                }
                Section(header: Text("Steps")) {
                    ForEach($sequence.steps) { $step in
                        VStack(alignment: .leading) {
                            TextField("Step Name", text: $step.name)
                            HStack {
                                Text("Duration:")
                                TextField("Duration", value: $step.duration, formatter: NumberFormatter())
                                    .keyboardType(.numberPad)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        sequence.steps.remove(atOffsets: indexSet)
                    }
                    Button(action: {
                        let newStep = TimerStep(name: "New Step", duration: 60)
                        sequence.steps.append(newStep)
                    }) {
                        Text("Add Step")
                    }
                }
            }
            .navigationTitle("Edit Sequence")
            .navigationBarItems(trailing: Button("Save") {
                onSave(sequence)
            })
        }
    }
}
