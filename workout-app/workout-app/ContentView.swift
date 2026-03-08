import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var blocks: [Block]

    var body: some View {
        NavigationStack {
            Group {
                if blocks.isEmpty {
                    ContentUnavailableView(
                        "No Training Blocks",
                        systemImage: "dumbbell",
                        description: Text("Tap + to start your first block")
                    )
                } else {
                    List {
                        ForEach(blocks) { block in
                            NavigationLink(destination: BlockDetailView(block: block)) {
                                BlockRowView(block: block)
                            }
                        }
                        .onDelete(perform: deleteBlock)
                    }
                }
            }
            .navigationTitle("Training Blocks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addBlock) {
                        Label("Add Block", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addBlock() {
        withAnimation {
            let block = Block(name: "Block \(blocks.count + 1)")
            modelContext.insert(block)

            // Auto-create 4 weeks
            for weekNum in 1...4 {
                let week = Week(weekNumber: weekNum)
                modelContext.insert(week)
                block.weeks.append(week)
            }
            
            try? modelContext.save()
        }
    }

    private func deleteBlock(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(blocks[index])
            }
        }
    }
}

struct BlockRowView: View {
    let block: Block

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(block.name)
                .font(.headline)
            Text(block.startDate, format: .dateTime.month().day().year())
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(block.isActive ? "Active" : "Completed")
                .font(.caption2)
                .foregroundStyle(block.isActive ? .green : .secondary)
        }
        .padding(.vertical, 4)
    }
}
