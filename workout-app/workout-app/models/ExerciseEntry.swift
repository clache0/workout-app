import SwiftData
import Foundation

@Model
class ExerciseEntry {
    var name: String
    var order: Int
    var sets: Int
    var reps: Int
    var weight: Double
    var rpe: Double?
    var notes: String
    
    init(name: String, order: Int = 0, sets: Int = 1, reps: Int = 0, weight: Double = 0) {
        self.name = name
        self.order = order
        self.sets = sets
        self.reps = reps
        self.weight = weight
        self.notes = ""
    }
}
