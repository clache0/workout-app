import SwiftUI
import SwiftData

struct BlockDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var block: Block
    @State private var showingEditName = false
    @State private var editedName = ""

    var body: some View {
        List {
            if block.weeks.isEmpty {
                ContentUnavailableView(
                    "No Weeks",
                    systemImage: "calendar",
                    description: Text("This block has no weeks")
                )
            } else {
                ForEach(block.weeks) { week in
                    Section(header: Text("Week \(week.weekNumber)")) {
                        ForEach(week.sessions) { session in
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
        let session = Session(title: "Session \(week.sessions.count + 1)")
        modelContext.insert(session)
        week.sessions.append(session)
        try? modelContext.save()
    }

    private func deleteSession(from week: Week, offsets: IndexSet) {
        for index in offsets {
            let session = week.sessions[index]   // 1. capture reference
            week.sessions.remove(at: index)      // 2. remove from array
            modelContext.delete(session)         // 3. delete from context
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
                Text(session.title)
                    .font(.headline)
                Spacer()
                Image(systemName: session.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(session.isCompleted ? .green : .secondary)
            }
            Text(session.date, format: .dateTime.month().day())
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("\(session.entries.count) exercises")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
