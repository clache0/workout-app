import SwiftUI
import SwiftData

struct BlockDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var block: Block
    @State private var showingEditName = false
    @State private var editedName = ""

    var sortedWeeks: [Week] {
        block.weeks.sorted { $0.weekNumber < $1.weekNumber }
    }

    func sortedSessions(for week: Week) -> [Session] {
        week.sessions.sorted { $0.order < $1.order }
    }

    var body: some View {
        List {
            if sortedWeeks.isEmpty {
                ContentUnavailableView(
                    "No Weeks",
                    systemImage: "calendar",
                    description: Text("This block has no weeks")
                )
            } else {
                ForEach(sortedWeeks) { week in
                    Section(header: Text("Week \(week.weekNumber)")) {
                        ForEach(sortedSessions(for: week)) { session in
                            NavigationLink(destination: SessionDetailView(session: session)) {
                                SessionRowView(session: session)
                            }
                        }
                        .onDelete { offsets in
                            deleteSession(from: week, offsets: offsets)
                        }
                        Button {
                            addSession(to: week)
                        } label: {
                            Label("Add Session", systemImage: "plus.circle")
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle(block.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    editedName = block.name
                    showingEditName = true
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
            }
        }
        .sheet(isPresented: $showingEditName) {
            EditBlockNameSheet(block: block, editedName: $editedName)
        }
    }

    private func addSession(to week: Week) {
        let session = Session(title: "Session \(week.sessions.count + 1)", order: week.sessions.count)
        modelContext.insert(session)
        week.sessions.append(session)
        try? modelContext.save()
    }

    private func deleteSession(from week: Week, offsets: IndexSet) {
        for index in offsets {
            let session = week.sessions[index]
            if let i = week.sessions.firstIndex(of: session) {
                week.sessions.remove(at: index)
            }
            modelContext.delete(session)
        }
        try? modelContext.save()
    }
}

// MARK: - Session Row
struct SessionRowView: View {
    let session: Session

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                // Text(session.title)
                //     .font(.headline)
                // Spacer()
                // Image(systemName: session.isCompleted ? "checkmark.circle.fill" : "circle")
                //     .foregroundStyle(session.isCompleted ? .green : .secondary)
                if session.entries.isEmpty {
                    Text("No exercises logged")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                } else {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(session.entries.sorted { $0.order < $1.order }) { entry in
                            HStack(spacing: 6) {
                                Text(entry.name)
                                    .font(.headline)
                                    .fontWeight(.medium)
                                Text("\(entry.sets)×\(entry.reps) @ \(entry.weight, specifier: "%.0f")lbs")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                                if let rpe = entry.rpe {
                                    Text("RPE \(rpe, specifier: "%.1f")")
                                        .font(.headline)
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                    }
                }
            }
            Text(session.date, format: .dateTime.month().day())
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
