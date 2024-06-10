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
                        HStack {
                            TextField("Step Name", text: $step.name)
                            Spacer()
                            HStack {
                                Text("Duration:")
                                TextField("Duration", value: $step.duration, formatter: NumberFormatter.decimal)
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

extension NumberFormatter {
    static var decimal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
}

struct SequenceEditorView_Previews: PreviewProvider {
    static var previews: some View {
        SequenceEditorView(
            sequence: TimerSequence(
                name: "Sample Sequence",
                steps: [
                    TimerStep(name: "Warm Up", duration: 300),
                    TimerStep(name: "High Intensity", duration: 60),
                    TimerStep(name: "Rest", duration: 90),
                    TimerStep(name: "Cool Down", duration: 300)
                ]
            ),
            onSave: { _ in }
        )
    }
}
