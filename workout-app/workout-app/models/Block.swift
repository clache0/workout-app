import SwiftData
import Foundation

@Model
class Block {
    var name: String
    var startDate: Date
    var endDate: Date?
    var isActive: Bool
    var notes: String
    
    @Relationship(deleteRule: .cascade) var weeks: [Week] = []
    
    init(name: String, startDate: Date = .now) {
        self.name = name
        self.startDate = startDate
        self.isActive = true
        self.notes = ""
    }
}
