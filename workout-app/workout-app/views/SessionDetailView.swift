import SwiftUI
import SwiftData

struct SessionDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var session: Session
    @State private var showingAddEntry = false

    var body: some View {
        List {
            if session.entries.isEmpty {
                ContentUnavailableView(
                    "No Exercises",
                    systemImage: "figure.strengthtraining.traditional",
                    description: Text("Tap + to log an exercise")
                )
            } else {
                ForEach(session.entries.sorted(by: { $0.order < $1.order })) { entry in
                    ExerciseEntryRow(entry: entry)
                }
                .onDelete(perform: deleteEntry)
            }

            Section("Session Notes") {
                TextField("Notes...", text: $session.notes, axis: .vertical)
                    .lineLimit(3...6)
            }
        }
        .navigationTitle(session.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddEntry = true
                } label: {
                    Label("Add Exercise", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddEntry) {
            AddExerciseEntrySheet(session: session)
        }
    }

    private func deleteEntry(offsets: IndexSet) {
        let sorted = session.entries.sorted(by: { $0.order < $1.order })
        for index in offsets {
            modelContext.delete(sorted[index])
        }
        try? modelContext.save()
        // TODO: deleting entry does not update session? entry.order getter failed
    }
}

// MARK: - Entry Row
struct ExerciseEntryRow: View {
    @Bindable var entry: ExerciseEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entry.name)
                .font(.headline)

            HStack(spacing: 16) {
                Label("\(entry.sets) sets", systemImage: "repeat")
                Label("\(entry.reps) reps", systemImage: "number")
                Label("\(entry.weight, specifier: "%.0f") lbs", systemImage: "scalemass")
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            if let rpe = entry.rpe {
                Text("RPE \(rpe, specifier: "%.1f")")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(.blue.opacity(0.15))
                    .foregroundStyle(.blue)
                    .clipShape(Capsule())
            }

            if !entry.notes.isEmpty {
                Text(entry.notes)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .italic()
            }
        }
        .padding(.vertical, 4)
    }
}
