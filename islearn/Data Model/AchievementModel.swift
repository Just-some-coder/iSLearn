import UIKit
import Foundation

struct Achievement : Codable{
    var achievementId: Int
    var name: String
    var description: String
    
    var currentLevel: Int
    var currentProgress : Double
    var maxProgress : Double {
        didSet{
            switch self.achievementId {
                case 1:
                self.description = "Learn \(Int(maxProgress)) Signs!"
            case 2:
                self.description = "Score Perfectly in \(Int(maxProgress)) Tests!"
            case 3:
                self.description = "Complete \(Int(maxProgress)) tests!"
            case 4:
                self.description = "Maintain \(Int(maxProgress)) streak!"
            case 5:
                self.description = "Achieve all achievements!"
            default:
                break
            }
        }
    }
    
    var completionXP: Int // XP for completing the current level
    var isCompleted: Bool {
        return currentLevel == 3
    }
    
    
  
}

class AchievementDataModel {
    static let sharedInstance = AchievementDataModel()
    private init() {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("achievements_list").appendingPathExtension( "plist" )
        
        let propertyDecoder = PropertyListDecoder()
        if let retrievedData = try? Data(contentsOf: archiveURl), let decodedAchievements = try? propertyDecoder.decode([Achievement].self, from: retrievedData){
            achievements = decodedAchievements
        }
    }
    
    private var achievements: [Achievement] = [
        
        Achievement(achievementId: 1, name: "Beginner", description: "Learn 5 Signs!", currentLevel: 1, currentProgress: 0, maxProgress: 5,  completionXP: 100),
        Achievement(achievementId: 2, name: "Perfectionist", description: "Score Perfectly in 5 Tests!", currentLevel: 1, currentProgress: 0, maxProgress: 5, completionXP: 100),
        Achievement(achievementId: 3, name: "Proficient", description: "Complete 5 tests!", currentLevel: 1, currentProgress: 0, maxProgress: 5, completionXP: 100),
        Achievement(achievementId: 4, name: "Streak Master", description: "Maintain 100 streak!", currentLevel: 1, currentProgress: 0, maxProgress: 100, completionXP: 100),
        Achievement(achievementId: 5, name: "Grand Master", description: "Achieve All Achievements!", currentLevel: 1, currentProgress: 0, maxProgress: 4, completionXP: 100)
        
    ]
    
    func updateProgress(forAchievementId id: Int, increment: Double) {
        guard let index = achievements.firstIndex(where: { $0.achievementId == id }) else {
            print("Achievement with ID \(id) not found.")
            return
       }
        
        var achievementUP = achievements[index]
        
        if(!achievementUP.isCompleted){
            if(achievementUP.currentLevel <= 3){
                achievementUP.currentProgress += increment
                if(achievementUP.currentProgress >= achievementUP.maxProgress){
                    achievementUP.currentLevel += 1
                    
                    //Notification Attempt
                    
                    let notification = UNMutableNotificationContent()
                    
                    notification.body = "Achievement Unlocked!"
                    
                    notification.title = "\(achievementUP.name)"
                    
                    notification.sound = .default
                    
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

                    let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: notification, trigger: trigger)

                    if(ProfileDataModel.sharedInstance.getNotificationSettings(1)!){
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    }
                    
                    
                    //Notification Attempt
                    achievementUP.currentProgress = Double(Int(achievementUP.currentProgress) % Int(achievementUP.maxProgress))
                    achievementUP.maxProgress = achievementUP.maxProgress * (3/2)
                    achievementUP.completionXP = achievementUP.completionXP * (3/2)
                    ProfileDataModel.sharedInstance.updateExperiencePoints(1, achievementUP.completionXP)
                    
                }
            }
        }
        else {
            achievementUP.name = "Completed!"
            achievementUP.currentProgress = achievementUP.maxProgress
           
        }
        
        achievements[index] = achievementUP
        
        saveToDirectory()
        
    }
    

    
    func resetToDefault() {
        achievements = loadDefaultAchievements()
        saveToDirectory()
        }
    func loadDefaultAchievements() -> [Achievement] {
        achievements = [
            
            Achievement(achievementId: 1, name: "Beginner", description: "Learn 5 Signs!", currentLevel: 1, currentProgress: 0, maxProgress: 5,  completionXP: 100),
            Achievement(achievementId: 2, name: "Perfectionist", description: "Score Perfectly in 5 Tests!", currentLevel: 1, currentProgress: 0, maxProgress: 5, completionXP: 100),
            Achievement(achievementId: 3, name: "Proficient", description: "Complete 5 tests!", currentLevel: 1, currentProgress: 0, maxProgress: 5, completionXP: 100),
            Achievement(achievementId: 4, name: "Streak Master", description: "Maintain 100 streak!", currentLevel: 1, currentProgress: 0, maxProgress: 100, completionXP: 100),
            Achievement(achievementId: 5, name: "Grand Master", description: "Achieve All Achievements!", currentLevel: 1, currentProgress: 0, maxProgress: 4, completionXP: 100)
            
        ]
        return achievements
                        }
    
    
    func getAchievementData(_ id : Int) -> Achievement? {
        return achievements.first{ $0.achievementId == id}
    }
    
    func getAchievementCount() -> Int {
        return achievements.count
    }
    func getAchievementData() -> [Achievement] {
        return achievements
    }
    
    private func saveToDirectory(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("achievements_list").appendingPathExtension( "plist" )
        
        let propertyEncoder = PropertyListEncoder()
        if let encodedValue = try? propertyEncoder.encode(achievements){
            try? encodedValue.write(to: archiveURl, options: .noFileProtection)
        }
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    func deleteData(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("achievements_list").appendingPathExtension( "plist" )
        
        try? FileManager.default.removeItem(at: archiveURl)
    }
}



struct Badge : Codable{
    let BadgeId : Int
    var name : String
    var description : String
    var isCompleted : Bool

}

class BadgesDataModel {
    
    private var badges : [Badge] = [Badge(BadgeId : 1,name: "1", description: "Complete lessons for 10 days straight!",isCompleted: false),
                                    Badge(BadgeId : 2,name: "25", description: "Complete lessons for 25 days straight!", isCompleted: false),
                                    Badge(BadgeId : 3,name: "50", description: "Complete lessons for 50 days straight!", isCompleted: false),
                                    Badge(BadgeId : 4,name: "100", description: "Complete lessons for 100 days straight!", isCompleted: false)]
    
    static let sharedInstance : BadgesDataModel = BadgesDataModel()
    
    private init (){
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("badges_list").appendingPathExtension( "plist" )
        
        let propertyDecoder = PropertyListDecoder()
        if let retrievedData = try? Data(contentsOf: archiveURl), let decodedBadges = try? propertyDecoder.decode([Badge].self, from: retrievedData){
            badges = decodedBadges
            print(badges[0].isCompleted)
        }
    }
    
    func getBadgesCount() -> Int {
        return badges.count
    }
    
    func getBadgesData(_ id:Int) -> Badge? {
        return badges.first{ $0.BadgeId == id}
    }
    
    func updateStreak(_ id:Int) -> Void {
        guard let index = badges.firstIndex(where: { $0.BadgeId == id }) else {return}
        badges[index].isCompleted = true
        for i in badges {
            ProfileDataModel.sharedInstance.updateCurrentStreak(i.BadgeId)
            
        }
        saveToDirectory()
    
    }
    
    func getStreakBadges() -> [Badge] {
        return badges
    }
    
    func resetToDefault() {
            badges = loadDefaultBadges()
        saveToDirectory()
        }
    
    func loadDefaultBadges() -> [Badge] {
        badges = [Badge(BadgeId : 1,name: "1", description: "Complete lessons for 10 days straight!",isCompleted: false),
                                        Badge(BadgeId : 2,name: "25", description: "Complete lessons for 25 days straight!", isCompleted: false),
                                        Badge(BadgeId : 3,name: "50", description: "Complete lessons for 50 days straight!", isCompleted: false),
                                        Badge(BadgeId : 4,name: "100", description: "Complete lessons for 100 days straight!", isCompleted: false)]
        return badges
    }
    
    private func saveToDirectory(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("badges_list").appendingPathExtension( "plist" )
        
        let propertyEncoder = PropertyListEncoder()
        if let encodedValue = try? propertyEncoder.encode(badges){
            try? encodedValue.write(to: archiveURl, options: .noFileProtection)
        }
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    func deleteData(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURl = documentsDirectory.appendingPathComponent("badges_list").appendingPathExtension( "plist" )
        
        try? FileManager.default.removeItem(at: archiveURl)
        
        
    }
    
}


