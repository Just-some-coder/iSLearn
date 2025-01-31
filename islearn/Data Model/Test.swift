import UIKit
import Foundation

struct Test : Codable{
    var title : String
    var description : String
    var questions : [Question]
    var themeColor : Color?
    var previousScore : Int = 0
    var newTest : Bool?
    var testID : Int?
    var testType : TestType?
}

struct Color: Codable {
    var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
    
    var uiColor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    init(uiColor: UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}


enum TestType : Equatable, Codable{
    case classic, gesture
    
    fileprivate var rawValue : String {
        switch self {
        case .classic:
            return "Classic"
        case .gesture:
            return "Gesture"
        }
    }
    
    static func == (lhs: TestType, rhs: TestType) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}



class TestDataModel {
    private var tests : [Test] = [
        Test(title: "Alphabets", description: "Learn The Alphabets",
             questions: [
                Question(questionTitle: .test, questionStatement: "Which Sign ifs A?", answer: 1, options: ["holi", "holi", "holi"], questionType: .mcqB, questionXP: 50),
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 2, options: ["A", "B","C","D"], questionType: .mcqA, questionXP: 50),
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 1, options: ["G", "H","K","I"], questionType: .mcqA, questionXP: 50),
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 3, options: ["A", "L","S","D"], questionType: .mcqA, questionXP: 50),
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 4, options: ["B", "R","U","H"], questionType: .mcqA, questionXP: 50),
             ],
             themeColor: Color.init(uiColor: .systemRed), previousScore: 0, testID: 11, testType: .classic),
        
        Test(title: "Alphabets", description: "Practice The Alphabets",
             questions: [
                Question(questionTitle: .test, questionStatement: "Perform The Sign", gestureWord: "A", questionType: .wordGesture, questionXP: 50),
             ],
             themeColor: Color.init(uiColor: .systemRed), previousScore: 0, testID: 21, testType: .gesture),
        
        Test(title: "Numbers", description: "Practice The Numbers",
             questions: [
                Question(questionTitle: .test, questionStatement: "Perform The Sign", gestureWord: "7", questionType: .wordGesture, questionXP: 50),
             ],
             themeColor: Color.init(uiColor: .systemBlue), previousScore: 0, testID: 22, testType: .gesture),
        
        Test(title: "Numbers", description: "Learn The Digits",
             questions: [
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 2, options: ["1", "9","8","4"], questionType: .mcqA, questionXP: 50),
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 1, options: ["2", "0","1","6"], questionType: .mcqA, questionXP: 50),
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 3, options: ["6", "9","0","1"], questionType: .mcqA, questionXP: 50),
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 1, options: ["1", "2","3","6"], questionType: .mcqA, questionXP: 50),
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 4, options: ["1", "7","2","9"], questionType: .mcqA, questionXP: 50),
                
             ],
             themeColor: Color.init(uiColor: .systemBlue), previousScore: 0, testID: 12, testType: .classic),
        
        Test(title: "Greeting People", description: "Learn how to meet and greet people",
             questions: [
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 2, options: ["Hello", "Good Morining","Good Evening","Rice"], questionType: .mcqA, questionXP: 50),
                
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 1, options: ["Greetings", "Hello", "Good Evening", "Bonjour"], questionType: .mcqA, questionXP: 50),
                
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 1, options: ["Greetings", "Hello", "Good Evening", "Bonjour"], questionType: .mcqA, questionXP: 50),
                
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 1, options: ["Greetings", "Hello", "Good Evening", "Bonjour"], questionType: .mcqA, questionXP: 50),
                
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 1, options: ["Greetings", "Hello", "Good Evening", "Bonjour"], questionType: .mcqA, questionXP: 50),
             ],
             themeColor: Color.init(uiColor: .systemYellow), previousScore: 0, testID: 13, testType: .classic),
        
        Test(title: "Friends & Family I", description: "Learn signs for friends and family",
             questions: [
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 2, options: ["Father", "Mother","Sister","Brother"], questionType: .mcqA, questionXP: 50),
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 2, options: ["Dog", "Father","Sister","Mother"], questionType: .mcqA, questionXP: 50),
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 2, options: ["Hello", "Mother","Father","Good Evening"], questionType: .mcqA, questionXP: 50),
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 2, options: ["A", "Father","Good Evening","Brother"], questionType: .mcqA, questionXP: 50),
                Question(questionTitle: .test, questionStatement: "Identify the Sign", answer: 2, options: ["Sister", "Mother","Cat","Brother"], questionType: .mcqA, questionXP: 50),
                
             ],
             themeColor: Color.init(uiColor: .systemPink), previousScore: 0, newTest: true, testID: 14, testType: .classic),
        
        Test(title: "Coming Soon", description: "More content will be added in the future", questions: [], themeColor: Color.init(uiColor: .systemGray), testID: 0, testType: nil)
        
    ]
    
    static var sharedInstance : TestDataModel = TestDataModel()
    
    private init (){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("tests_list").appendingPathExtension( "plist" )
        
        let propertyDecoder = PropertyListDecoder()
        if let retrievedData = try? Data(contentsOf: archiveURl), let decodedTests = try? propertyDecoder.decode([Test].self, from: retrievedData){
            tests = decodedTests
        }
    }
    
    func giveTest(_ byID : Int) -> Test? {
        return self.tests.first {$0.testID == byID}
    }
    
    func giveTest(_ byID : Int, _ byType : TestType) -> Test? {
        return self.tests.first {($0.testType == byType && $0.testID == byID) || ($0.testType == nil)}
    }
    
    func updateScore(_ byID : Int, _ newScore : Int){
        
        if giveTest(byID) != nil {
            let index = tests.firstIndex(where: {$0.testID == byID})
            tests[index!].previousScore = newScore
            saveToDirectory()
        }
        
        
    }
    
    func giveTestCount(testType : TestType) -> Int{
        return (tests.filter{$0.testType == testType}.count) + 1
    }
    
    func saveToDirectory(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("tests_list").appendingPathExtension( "plist" )
        
        let propertyEncoder = PropertyListEncoder()
        if let encodedValue = try? propertyEncoder.encode(tests){
            try? encodedValue.write(to: archiveURl, options: .noFileProtection)
        }
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    func deleteData(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("tests_list").appendingPathExtension( "plist" )
        
        try? FileManager.default.removeItem(at: archiveURl)
        
        print(documentsDirectory)
    }
    
}

