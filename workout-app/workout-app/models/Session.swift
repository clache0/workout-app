import SwiftData
import Foundation

@Model
class Session {
    var date: Date
    var title: String          // e.g. "Upper A", "Lower B"
    var order: Int
    var isCompleted: Bool
    var notes: String
    
    @Relationship(deleteRule: .cascade) var entries: [ExerciseEntry] = []
    
    init(title: String, date: Date = .now, order: Int = 0) {
        self.title = title
        self.date = date
        self.order = order
        self.isCompleted = false
        self.notes = ""
    }
}
