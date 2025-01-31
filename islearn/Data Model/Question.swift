struct Question : Codable{
    var questionTitle : QuestionTitle
    var questionStatement : String
    var gestureWord : String?
    var answer : Int? // enum or int
    var options : [String]?
    var questionType : QuestionType
    var questionXP : Int
}

enum QuestionTitle : String, Codable{
    
    case practice, test
    
    var description : String{
        switch self {
            
        case .practice:
            return "Practice"
        case .test:
            return "Test"
        }
        
    }
}

enum QuestionType : Codable{
    case mcqA, mcqB, wordGesture, spellGesture
}
