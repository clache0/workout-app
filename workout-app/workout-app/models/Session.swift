import SwiftData
import Foundation

@Model
class Session {
    var date: Date
    var title: String          // e.g. "Upper A", "Lower B"
    var isCompleted: Bool
    var notes: String
    
    @Relationship(deleteRule: .cascade) var entries: [ExerciseEntry] = []
    
    init(title: String, date: Date = .now) {
        self.title = title
        self.date = date
        self.isCompleted = false
        self.notes = ""
    }
}
