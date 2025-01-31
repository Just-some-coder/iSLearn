import UIKit
import Foundation

struct Word : Hashable, Codable{
    var wordName : String
    var wordDefinition : String
    var videoURL : String
}

class WordDataModel {
    private var words: [Word] = [
        Word(wordName: "Experience", wordDefinition: "Experience is the knowledge or skill gained through involvement in or exposure to a particular activity or field over time.", videoURL: "holi"),
        Word(wordName: "Particular", wordDefinition: "You use 'particular' to emphasize that something is specific or distinctive within a larger group or category.", videoURL: "holi"),
        Word(wordName: "Assess", wordDefinition: "When you assess a person, thing, or situation, you evaluate or judge its quality, importance, or effectiveness.", videoURL: "holi"),
        Word(wordName: "Anxiety", wordDefinition: "A feeling of nervousness or worry.", videoURL: "holi"),
        Word(wordName: "Depression", wordDefinition: "Depression is a mental state in which an individual experiences persistent feelings of sadness", videoURL: "holi"),
        Word(wordName: "Mariachi", wordDefinition: "A small group of musicians playing Mexican music...", videoURL: "holi"),
        Word(wordName: "Resilience", wordDefinition: "The ability to recover from setbacks, adapt well to change, and keep going in the face of adversity.", videoURL: "holi"),
        Word(wordName: "Cognition", wordDefinition: "The mental action or process of acquiring knowledge and understanding through thought, experience, and the senses.", videoURL: "holi"),
        Word(wordName: "Perspective", wordDefinition: "A particular attitude toward or way of regarding something; a point of view.", videoURL: "holi"),
        Word(wordName: "Empathy", wordDefinition: "The ability to understand and share the feelings of another.", videoURL: "holi"),
        Word(wordName: "Innovation", wordDefinition: "The action or process of innovating, introducing new ideas or methods.", videoURL: "holi"),
        Word(wordName: "Collaboration", wordDefinition: "The action of working with someone to produce or create something.", videoURL: "holi"),
        Word(wordName: "Diversity", wordDefinition: "The state of being diverse; a range of different things or qualities.", videoURL: "holi"),
        Word(wordName: "Sustainability", wordDefinition: "The ability to be maintained at a certain rate or level without depleting resources.", videoURL: "holi"),
        Word(wordName: "Persuasion", wordDefinition: "The act of convincing someone to do or believe something through reasoning or argument.", videoURL: "holi"),
        Word(wordName: "Altruism", wordDefinition: "The belief in or practice of selfless concern for the well-being of others.", videoURL: "holi")
    ]

    
    static let sharedInstance : WordDataModel = WordDataModel()
    
    private init (){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("words_list").appendingPathExtension( "plist" )
        
        let propertyDecoder = PropertyListDecoder()
        if let retrievedData = try? Data(contentsOf: archiveURl), let decodedWords = try? propertyDecoder.decode([Word].self, from: retrievedData){
            words = decodedWords
        }
    }
    
    func fetchAllWords() -> [Word] {
        return words
    }
    
    func giveWord(_ byName : String) -> Word? {
        words.first { $0.wordName == byName }
    }
    
    
    func giveMatching(_ compareString : String) -> [Word] {
        words.filter { $0.wordName.contains(compareString) }
        
    }
    
    func saveToDirectory(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("words_list").appendingPathExtension( "plist" )
        
        let propertyEncoder = PropertyListEncoder()
        if let encodedValue = try? propertyEncoder.encode(words){
            try? encodedValue.write(to: archiveURl, options: .noFileProtection)
        }
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    func deleteData(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("words_list").appendingPathExtension( "plist" )
        
        try? FileManager.default.removeItem(at: archiveURl)
    }
}

class WordOfTheDay {
    private var words: [Word: Date] = [
        Word(
            wordName: "Independence",
            wordDefinition: "Freedom from being governed or ruled by another country",
            videoURL: "holi"
        ): Date()
    ]
    
    // Corrected singleton declaration
    static let sharedInstance = WordOfTheDay()
    
    private init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("wotd_list").appendingPathExtension( "plist" )
        
        let propertyDecoder = PropertyListDecoder()
        if let retrievedData = try? Data(contentsOf: archiveURl), let decodedWOTD = try? propertyDecoder.decode([Word:Date].self, from: retrievedData){
            words = decodedWOTD
        }
    } // Private initializer to enforce singleton
    
    func getWordOfTheDay() -> Word? {
        let today = Calendar.current.startOfDay(for: Date()) 
        return words.first { Calendar.current.startOfDay(for: $0.value) == today }?.key
    }
    
    func saveToDirectory(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("wotd_list").appendingPathExtension( "plist" )
        
        let propertyEncoder = PropertyListEncoder()
        if let encodedValue = try? propertyEncoder.encode(words){
            try? encodedValue.write(to: archiveURl, options: .noFileProtection)
        }
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    func deleteData(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("wotd_list").appendingPathExtension( "plist" )
        
        try? FileManager.default.removeItem(at: archiveURl)
    }
}

class BookMarkedWords {
    private var bookmarkedWords : [Word] = []
    
    static let sharedInstance = BookMarkedWords()
    
    private init (){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("bookmarkedWords_list").appendingPathExtension( "plist" )
        
        let propertyDecoder = PropertyListDecoder()
        if let retrievedData = try? Data(contentsOf: archiveURl), let decodedBookWords = try? propertyDecoder.decode([Word].self, from: retrievedData){
            bookmarkedWords = decodedBookWords
        }
    }
    
    func toggleBookmarkedWords(_ word : Word){
        if bookmarkedWords.contains(word){
            bookmarkedWords.removeAll { $0.wordName == word.wordName }
        }else{
            bookmarkedWords.append(word)
        }
        saveToDirectory()
    }
    
    func getBookmarkedWords() -> [Word] {
        return bookmarkedWords
    }
    func saveToDirectory(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("bookmarkedWords_list").appendingPathExtension( "plist" )
        
        let propertyEncoder = PropertyListEncoder()
        if let encodedValue = try? propertyEncoder.encode(bookmarkedWords){
            try? encodedValue.write(to: archiveURl, options: .noFileProtection)
        }
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    func deleteData(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("bookmarkedWords_list").appendingPathExtension( "plist" )
        
        try? FileManager.default.removeItem(at: archiveURl)
    }
    
}






