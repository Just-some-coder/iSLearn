import Foundation
import UIKit

extension UIColor {
    static let themeColor = UIColor(red: 0/255, green: 161/255, blue: 255/255, alpha: 1.0)
}

struct RectangularButton : Codable{
    var color: Color
    var title: String
    var description: String
}

struct Exercise : Codable{
    var name: String
    var completed: Bool
    var isLocked: Bool
}

struct Section : Codable {
    var title: String
    var exercises: [Exercise]
}

struct Journey : Codable{
    var section: [Section]
}

class JourneyDataModel {
    static var shared = JourneyDataModel()
    var journey = Journey(section: [
        Section(title: "Alphabets", exercises: [
            Exercise(name: "A", completed: false, isLocked: false),
            Exercise(name: "B", completed: false, isLocked: true),
            Exercise(name: "C", completed: false, isLocked: true),
            Exercise(name: "D", completed: false, isLocked: true),
            Exercise(name: "E", completed: false, isLocked: true),
            Exercise(name: "F", completed: false, isLocked: true),
            Exercise(name: "G", completed: false, isLocked: true),
            Exercise(name: "H", completed: false, isLocked: true),
            Exercise(name: "I", completed: false, isLocked: true),
            Exercise(name: "J", completed: false, isLocked: true),
            Exercise(name: "K", completed: false, isLocked: true),
            Exercise(name: "L", completed: false, isLocked: true),
            Exercise(name: "M", completed: false, isLocked: true),
            Exercise(name: "N", completed: false, isLocked: true),
            Exercise(name: "O", completed: false, isLocked: true),
            Exercise(name: "P", completed: false, isLocked: true),
            Exercise(name: "Q", completed: false, isLocked: true),
            Exercise(name: "R", completed: false, isLocked: true),
            Exercise(name: "S", completed: false, isLocked: true),
            Exercise(name: "T", completed: false, isLocked: true),
            Exercise(name: "U", completed: false, isLocked: true),
            Exercise(name: "V", completed: false, isLocked: true),
            Exercise(name: "W", completed: false, isLocked: true),
            Exercise(name: "X", completed: false, isLocked: true),
            Exercise(name: "Y", completed: false, isLocked: true),
            Exercise(name: "Z", completed: false, isLocked: true)
        ]),
        Section(title: "Numbers", exercises: [
            Exercise(name: "1", completed: false, isLocked: true),
            Exercise(name: "2", completed: false, isLocked: true),
            Exercise(name: "3", completed: false, isLocked: true),
            Exercise(name: "4", completed: false, isLocked: true),
            Exercise(name: "5", completed: false, isLocked: true),
            Exercise(name: "6", completed: false, isLocked: true),
            Exercise(name: "7", completed: false, isLocked: true),
            Exercise(name: "8", completed: false, isLocked: true),
            Exercise(name: "9", completed: false, isLocked: true),
        ]),
        
    ])
    
    private init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("journey_list").appendingPathExtension( "plist" )
        
        let propertyDecoder = PropertyListDecoder()
        if let retrievedData = try? Data(contentsOf: archiveURl), let decodedJourney = try? propertyDecoder.decode(Journey.self, from: retrievedData){
            journey = decodedJourney
        }
    }
    
    func completeExercise(sectionTitle: String, exerciseName: String) {
        guard let sectionIndex = journey.section.firstIndex(where: { $0.title == sectionTitle }),
              let exerciseIndex = journey.section[sectionIndex].exercises.firstIndex(where: { $0.name == exerciseName }) else {
            return
        }
        
        var exercise = journey.section[sectionIndex].exercises[exerciseIndex]
        exercise.completed = true
        journey.section[sectionIndex].exercises[exerciseIndex] = exercise
        unlockNextExercise(in: sectionTitle, after: exerciseName)
        if exerciseIndex == journey.section[sectionIndex].exercises.count - 1 {
            unlockFirstExerciseOfNextSection(from: sectionIndex)
        }
        saveToDirectory()
    }
   
    func unlockNextExercise(in sectionTitle: String, after exerciseName: String) {
        guard let sectionIndex = journey.section.firstIndex(where: { $0.title == sectionTitle }),
              let exerciseIndex = journey.section[sectionIndex].exercises.firstIndex(where: { $0.name == exerciseName }),
              exerciseIndex + 1 < journey.section[sectionIndex].exercises.count else {
            return
        }
        var nextExercise = journey.section[sectionIndex].exercises[exerciseIndex + 1]
        nextExercise.isLocked = false
        journey.section[sectionIndex].exercises[exerciseIndex + 1] = nextExercise
        
        saveToDirectory()
    }
    
    func unlockFirstExerciseOfNextSection(from sectionIndex: Int) {
        if sectionIndex + 1 < journey.section.count {
            let nextSection = journey.section[sectionIndex + 1]
            if !nextSection.exercises.isEmpty {
                var firstExercise = nextSection.exercises[0]
                firstExercise.isLocked = false
                journey.section[sectionIndex + 1].exercises[0] = firstExercise
            }
        }
        saveToDirectory()
    }
    
    func isExerciseCompleted(sectionTitle: String, exerciseName: String) -> Bool {
        if let section = journey.section.first(where: { $0.title == sectionTitle }) {
            if let exercise = section.exercises.first(where: { $0.name == exerciseName }) {
                return exercise.completed
            }
        }
        return false
    }
   
    func isExerciseLocked(sectionTitle: String, exerciseName: String) -> Bool {
        if let section = journey.section.first(where: { $0.title == sectionTitle }) {
            if let exercise = section.exercises.first(where: { $0.name == exerciseName }) {
                return exercise.isLocked
            }
        }
        return true
    }
    
    func saveToDirectory(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("journey_list").appendingPathExtension( "plist" )
        
        let propertyEncoder = PropertyListEncoder()
        if let encodedValue = try? propertyEncoder.encode(journey){
            try? encodedValue.write(to: archiveURl, options: .noFileProtection)
        }
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    func deleteData(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("journey_list").appendingPathExtension( "plist" )
        
        try? FileManager.default.removeItem(at: archiveURl)
    }
}
