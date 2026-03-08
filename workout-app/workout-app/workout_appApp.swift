import SwiftUI
import SwiftData

@main
struct workout_appApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Block.self,
            Week.self,
            Session.self,
            ExerciseEntry.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: modelConfiguration)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    seedDataIfNeeded(context: sharedModelContainer.mainContext)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}

func seedDataIfNeeded(context: ModelContext) {
    let descriptor = FetchDescriptor<Block>()
    let existing = try? context.fetch(descriptor)
    guard existing?.isEmpty == true else { return }

    let block = Block(name: "Strength Block 1")
    block.isActive = true

    let week1 = Week(weekNumber: 1)
    context.insert(week1)

    let session1 = Session(title: "Upper A")
    context.insert(session1)

    let entry1 = ExerciseEntry(name: "Back Squat", order: 0, sets: 3, reps: 5, weight: 225)
    entry1.rpe = 8
    entry1.notes = "Felt strong"
    context.insert(entry1)

    let entry2 = ExerciseEntry(name: "Bench Press", order: 1, sets: 3, reps: 5, weight: 165)
    entry2.rpe = 7.5
    context.insert(entry2)

    session1.entries = [entry1, entry2]
    week1.sessions = [session1]
    block.weeks = [week1]

    context.insert(block)
    try? context.save()
}
