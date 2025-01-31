import UIKit
import Foundation

struct Profile : Codable{
    var name : String
    var image : Image
    var id : Int
    var totalExperiencePoints : Int
    var currentStreak : Int
    var userLongestStreak : Int
    var userStreakBadges : [Badge] = []
    var userAchievements : [Achievement] = []
    var notifications : Bool = false
    var wordsLearned : Int
    var lastActiveDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
    
    
    mutating func updateStreak() {
        let calendar = Calendar.current
                let today = calendar.startOfDay(for: Date())
                
                guard let lastActiveDay = lastActiveDate else {
                    currentStreak = 1
                    lastActiveDate = today
                    userLongestStreak = max(userLongestStreak, currentStreak)
                    return
                }
                let dayDifference = calendar.dateComponents([.day], from: calendar.startOfDay(for: lastActiveDay), to: today).day ?? 0

                if dayDifference == 1 {
                    currentStreak += 1
                } else if dayDifference > 1 {
                    currentStreak = 1
                }

                lastActiveDate = today

                userLongestStreak = max(userLongestStreak, currentStreak)
    }
    
    var showOnboarding = true

}

public struct Image: Codable {

    public var photo: Data
    
    public init(photo: UIImage) {
        self.photo = photo.pngData()!
    }
    
}

class ProfileDataModel{
    static let sharedInstance = ProfileDataModel()
    private init(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("profiles_list").appendingPathExtension( "plist" )
        
        let propertyDecoder = PropertyListDecoder()
        if let retrievedData = try? Data(contentsOf: archiveURl), let decodedProfiles = try? propertyDecoder.decode([Profile].self, from: retrievedData){
            profiles = decodedProfiles
        }
    }
    
    private var profiles : [Profile] = [Profile(name: "Persephone", image: Image(photo: UIImage(named: "TempProfile")!) ,id: 1, totalExperiencePoints: 0, currentStreak: 0, userLongestStreak: 5, userStreakBadges: BadgesDataModel.sharedInstance.getStreakBadges(), userAchievements: AchievementDataModel.sharedInstance.getAchievementData(), notifications: true, wordsLearned: 0)]
    
    func getProfileData(_ id:Int) -> Profile? {
        return profiles.first { $0.id == id }
        
    }
    
    func getProfileImage(_ id:Int) -> UIImage? {
        return UIImage(data:(profiles.first { $0.id == id }!.image.photo))
    }
    
    func updateProfileData(_ id: Int, _ username: String, _ userProfile: UIImage, _ userNotif: Bool) {
        
        guard let index = profiles.firstIndex(where: { $0.id == id }) else {
            print("Achievement with ID \(id) not found.")
            return
       }
        
        var person = profiles[index]
        
        person.image.photo = userProfile.pngData()!
        person.name = username
        person.notifications = userNotif
        
        profiles[index] = person
        print(person.name)
        
        saveToDirectory()
        
    }
    
    func resetToDefault() {
        profiles = loadDefaultProfiles()
        saveToDirectory()
        }
    
    func loadDefaultProfiles() -> [Profile] {
        return [Profile(name: "User Name", image: Image(photo: UIImage(named: "deleteUser")!) ,id: 1, totalExperiencePoints: 0, currentStreak: 0, userLongestStreak: 5, userStreakBadges: BadgesDataModel.sharedInstance.getStreakBadges(), userAchievements: AchievementDataModel.sharedInstance.getAchievementData(), notifications: true, wordsLearned: 0)]
    }
    
    func getNotificationSettings(_ id: Int) -> Bool? {
        return profiles.first{$0.id == id}?.notifications
    }
    
    func updateNumberOfWordsLearned(_ id: Int) {
        guard let index = profiles.firstIndex(where: { $0.id == id }) else {
            print("Achievement with ID \(id) not found.")
            return
       }
        
        profiles[index].wordsLearned += 1
        
        saveToDirectory()
        
     
    }
    
    func updateExperiencePoints(_ id: Int, _ points: Int) {
        guard let index = profiles.firstIndex(where: { $0.id == id }) else {
            print("Achievement with ID \(id) not found.")
            return
       }
        
        profiles[index].totalExperiencePoints += points
        
        saveToDirectory()
    }

    func updateCurrentStreak(_ id: Int) {
        guard let index = profiles.firstIndex(where: { $0.id == id }) else {
            print("Achievement with ID \(id) not found.")
            return
       }
        var person = profiles[index]
        person.updateStreak()
        profiles[index] = person
        
        saveToDirectory()
    }
    
    func setOnboarding(_ id : Int){
        guard let index = profiles.firstIndex(where: { $0.id == id }) else {return}
        var person = profiles[index]
        person.showOnboarding = false
        profiles[index] = person
        
        saveToDirectory()
    }
    
    func getOnboarding(_ id : Int)->Bool{
        guard let index = profiles.firstIndex(where: { $0.id == id }) else {return false}
        let person = profiles[index]
        return person.showOnboarding
    }
    
    private func saveToDirectory(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("profiles_list").appendingPathExtension( "plist" )
        
        let propertyEncoder = PropertyListEncoder()
        if let encodedValue = try? propertyEncoder.encode(profiles){
            try? encodedValue.write(to: archiveURl, options: .noFileProtection)
        }
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    func deleteData(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("profiles_list").appendingPathExtension( "plist" )
        
        try? FileManager.default.removeItem(at: archiveURl)
        
    }
    
    
    
}
