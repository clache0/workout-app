import SwiftUI
import SwiftData

struct AddExerciseEntrySheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var session: Session

    @State private var name = ""
    @State private var sets = "3"
    @State private var reps = "5"
    @State private var weight = ""
    @State private var rpe = 7.0
    @State private var includeRPE = true
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Exercise") {
                    TextField("e.g. Back Squat", text: $name)
                }

                Section("Volume") {
                    HStack {
                        TextField("Sets", text: $sets)
                            .keyboardType(.numberPad)
                        Text("sets")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        TextField("Reps", text: $reps)
                            .keyboardType(.numberPad)
                        Text("reps")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        TextField("Weight", text: $weight)
                            .keyboardType(.decimalPad)
                        Text("lbs")
                            .foregroundStyle(.secondary)
                    }
                }

                Section {
                    Toggle("Log RPE", isOn: $includeRPE)
                    if includeRPE {
                        VStack(alignment: .leading) {
                            Text("RPE: \(rpe, specifier: "%.1f")")
                                .font(.subheadline)
                            Slider(value: $rpe, in: 1...10, step: 0.5)
                                .tint(.blue)
                        }
                    }
                }

                Section("Notes") {
                    TextField("Optional notes...", text: $notes, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle("Log Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                        dismiss()
                    }
                    .disabled(name.isEmpty || weight.isEmpty)
                }
            }
        }
        .presentationDetents([.large])
    }

    private func saveEntry() {
        let entry = ExerciseEntry(
            name: name,
            order: session.entries.count,
            sets: Int(sets) ?? 1,
            reps: Int(reps) ?? 0,
            weight: Double(weight) ?? 0
        )
        entry.rpe = includeRPE ? rpe : nil
        entry.notes = notes
        modelContext.insert(entry)
        session.entries.append(entry)
        try? modelContext.save()
    }
}
