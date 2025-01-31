import UIKit

class TestProfilePageViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var achievementsCollection: UICollectionView!
    
    
    @IBOutlet weak var badgesCollection: UICollectionView!
    
    @IBOutlet weak var longestStreakLabel: UILabel!
    @IBOutlet weak var learnedWordsLabel: UILabel!
    
    @IBOutlet weak var totalExperienceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileLoad()
        
        badgesCollection.delegate = self
        badgesCollection.dataSource = self
        
        achievementsCollection.delegate = self
        achievementsCollection.dataSource = self
        
        
        setupStreakLabel()
        setupTotalExperienceLabel()
        setupLearnedWordsLabel()
        badgesCollection.reloadData()
        
        setCollectionViewContentHeight()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        achievementsCollection.reloadData()
        badgesCollection.reloadData()
        setupStreakLabel()
        setupTotalExperienceLabel()
        setupLearnedWordsLabel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        achievementsCollection.heightAnchor.constraint(equalToConstant:
                                                        achievementsCollection.contentSize.height).isActive = true
    }
    
    func setupStreakLabel() {
        
        let profile = ProfileDataModel.sharedInstance.getProfileData(1)!
        let streak = profile.currentStreak
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 27, weight: .regular)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "flame.fill", withConfiguration: symbolConfig)?  .withRenderingMode(.alwaysTemplate)
        
        let attributedString = NSMutableAttributedString(string: "\(streak) ")
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedString.length - 1))
        longestStreakLabel.textColor = .systemOrange
        longestStreakLabel.attributedText = attributedString
        
    }
    
    func setupTotalExperienceLabel() {
        
        let profile = ProfileDataModel.sharedInstance.getProfileData(1)!
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 27, weight: .regular)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "bolt.fill", withConfiguration: symbolConfig)?  .withRenderingMode(.alwaysTemplate)
        
        let totalExperiencePoints = profile.totalExperiencePoints
        
        let attributedString = NSMutableAttributedString(string: "\(totalExperiencePoints) ")
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedString.length - 1))
        
        totalExperienceLabel.textColor = .systemYellow
        totalExperienceLabel.attributedText = attributedString
        
    }
    
    func setupLearnedWordsLabel() {
        let profile = ProfileDataModel.sharedInstance.getProfileData(1)!
        let learntWords = profile.wordsLearned
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 27, weight: .regular)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "book.fill", withConfiguration: symbolConfig)?  .withRenderingMode(.alwaysTemplate)
        
        let attributedString = NSMutableAttributedString(string: "\(learntWords) ")
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedString.length - 1))
        
        learnedWordsLabel.textColor = .systemBlue
        learnedWordsLabel.attributedText = attributedString
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    
    func profileLoad(){
        
        let profile = ProfileDataModel.sharedInstance.getProfileData(1)!
        
        profileImage.image = UIImage(data:profile.image.photo)
        userName.text = profile.name
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == badgesCollection {
            return BadgesDataModel.sharedInstance.getBadgesCount()
        } else{
            print(AchievementDataModel.sharedInstance.getAchievementCount())
            return AchievementDataModel.sharedInstance.getAchievementCount()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == badgesCollection{
            return CGSize(width: 110, height: 115)}
        else {
            return CGSize(width: 420, height: 125)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == badgesCollection {
            return 10
        }else {
            return 30
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == badgesCollection {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "badge", for: indexPath) as? BadgeCollectionViewCell else {
                fatalError("Could not dequeue BadgeCollectionViewCell")
            }
            
            let badge = BadgesDataModel.sharedInstance.getBadgesData(indexPath.item+1)!
            
            cell.badgeImage.image = UIImage(systemName: "hexagon")
            cell.badgeImage.center = cell.contentView.center
            cell.badgeLabel.text = badge.name
            cell.badgeImage.contentMode = .scaleToFill
            if(badge.isCompleted){
                cell.badgeImage.tintColor = .systemOrange
            } else {
                cell.badgeImage.tintColor = .gray
            }
            collectionView.showsHorizontalScrollIndicator = false
            return cell
        }
        else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "achievement", for: indexPath) as! AchievementsCollectionViewCell
            
            let achievement = AchievementDataModel.sharedInstance.getAchievementData(indexPath.item+1)!
            
            cell.MainTrophy.image = UIImage(systemName: "trophy.fill")
            cell.bronzeTrophy.image = UIImage(systemName: "trophy.fill")
            cell.silverTrophy.image = UIImage(systemName: "trophy.fill")
            cell.goldTrophy.image = UIImage(systemName: "trophy.fill")
            switch achievement.currentLevel {
            case 1:
                cell.MainTrophy.tintColor = .maroon
                cell.bronzeTrophy.tintColor = .maroon
                cell.silverTrophy.tintColor = .darkGray
                cell.goldTrophy.tintColor = .darkGray
                
            case 2:
                cell.MainTrophy.tintColor = .silver
                cell.bronzeTrophy.tintColor = .maroon
                cell.silverTrophy.tintColor = .silver
                cell.goldTrophy.tintColor = .darkGray
            case 3:
                cell.MainTrophy.tintColor = .golden
                cell.bronzeTrophy.tintColor = .maroon
                cell.silverTrophy.tintColor = .silver
                cell.goldTrophy.tintColor = .golden
            default :
                cell.MainTrophy.tintColor = .darkGray
                cell.bronzeTrophy.tintColor = .darkGray
                cell.silverTrophy.tintColor = .darkGray
                cell.goldTrophy.tintColor = .darkGray
            }
            
            
            
            cell.achievementProgress.progress = Float(Double(achievement.currentProgress) / achievement.maxProgress)
            print(cell.achievementProgress.progress)
            cell.achievementTitle.text = achievement.name
            cell.achievementDetail.text = achievement.description
            
            achievementsCollection.showsVerticalScrollIndicator = false
            return cell
            
        }
    }
    
    @IBAction func unwindToProfileViewController(segue: UIStoryboardSegue) {
        
        guard let sourceVC = segue.source as? ProfileEditViewController else {return}
        profileImage.image = sourceVC.editProfileImage.image
        userName.text = sourceVC.newNameTextField.text
        
        ProfileDataModel.sharedInstance.updateProfileData(1, sourceVC.newNameTextField.text!, sourceVC.editProfileImage.image!, sourceVC.pushNotification.isOn)
    }
    
    @IBAction func unwindToCancelProfileViewController(segue: UIStoryboardSegue) {
    }
    
    func setCollectionViewContentHeight() {
       
        let contentHeight = achievementsCollection.collectionViewLayout.collectionViewContentSize.height
        
        achievementsCollection.heightAnchor.constraint(equalToConstant: contentHeight).isActive = true
    }
}
