import SwiftData
import Foundation

@Model
class Week {
    var weekNumber: Int        // 1–4
    var notes: String
    
    @Relationship(deleteRule: .cascade) var sessions: [Session] = []
    
    init(weekNumber: Int) {
        self.weekNumber = weekNumber
        self.notes = ""
    }
}
