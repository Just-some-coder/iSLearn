//
//  TestResultViewController.swift
//  islearn
//
//  Created by student-2 on 18/12/24.
//

import UIKit

class TestResultViewController: UIViewController {
    
    var testID : Int?
    
    var testScore : Double?
    
    var testXP : Int?
    
    
    @IBOutlet weak var star1ImageView: UIImageView!
    
    @IBOutlet weak var star2ImageView: UIImageView!
    
    @IBOutlet weak var star3ImageView: UIImageView!
    
    @IBOutlet weak var star4ImageView: UIImageView!
    
    @IBOutlet weak var star5ImageView: UIImageView!
    
    @IBOutlet weak var resultImageView: UIImageView!
    
    @IBOutlet weak var resultComment1: UILabel!
    
    @IBOutlet weak var resultComment2: UILabel!
    
    @IBOutlet weak var resultXPLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 17.5, *) {
            let haptic = UIImpactFeedbackGenerator(style: .light, view: view)
            haptic.impactOccurred(intensity: 1)
        }
        
        updateResultScreen()
    }
    
    func updateResultScreen(){
        let temp = TestDataModel.sharedInstance.giveTest(testID!)
        
        star1ImageView.isHidden = true
        star2ImageView.isHidden = true
        star3ImageView.isHidden = true
        star4ImageView.isHidden = true
        star5ImageView.isHidden = true
        
        if (temp!.previousScore >= Int(testScore!*5)){
            resultXPLabel.text = "+ \(Int(Double(testXP!)*(0.1))) XP"
        }else{
            resultXPLabel.text = "+ \(testXP!) XP"
        }
        
        if let testScore {
            
            if testScore == 0 {
                star1ImageView.isHidden = false
                star2ImageView.isHidden = false
                star3ImageView.isHidden = false
                star4ImageView.isHidden = false
                star5ImageView.isHidden = false
                
                star1ImageView.tintColor = .systemGray
                star2ImageView.tintColor = .systemGray
                star3ImageView.tintColor = .systemGray
                star4ImageView.tintColor = .systemGray
                star5ImageView.tintColor = .systemGray
                
                resultComment1.text = "You need to work on your skills!"
                resultComment2.text = "Poor performance"
                
                return
            }
            if (testScore <= 0.2) {
                star1ImageView.isHidden = false
                
                resultComment1.text = "Focus more"
                resultComment2.text = "Work More"
                
                return
            }
            if (testScore <= 0.4){
                star1ImageView.isHidden = false
                star2ImageView.isHidden = false
                
                
                resultComment1.text = "More work can be done"
                resultComment2.text = "Practice More"
                
                
                return
            }
            
            if(testScore <= 0.6){
                star1ImageView.isHidden = false
                star2ImageView.isHidden = false
                star3ImageView.isHidden = false
                
                resultComment1.text = "Keep it up!"
                resultComment2.text = "Exceeded Expectations"
                
                
                return
            }
            if(testScore <= 0.8){
                star1ImageView.isHidden = false
                star2ImageView.isHidden = false
                star3ImageView.isHidden = false
                star4ImageView.isHidden = false
                
                resultComment1.text = "Good Job!"
                resultComment2.text = "Good Performance"
                
                return
            }
            
            if(testScore <= 1){
                star1ImageView.isHidden = false
                star2ImageView.isHidden = false
                star3ImageView.isHidden = false
                star4ImageView.isHidden = false
                star5ImageView.isHidden = false
                
                resultComment1.text = "Awesome Work!"
                resultComment2.text = "Awesome Performance"
                
                return
            }
        }
    }
    
    @IBAction func unwindToTestCancel(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationVC = segue.destination as? TestListCollectionViewController else {return}
        
        let temp = TestDataModel.sharedInstance.giveTest(testID!)
        
        let newScore = Int(testScore!*5)
        
        if(newScore > temp!.previousScore){
            
            TestDataModel.sharedInstance.updateScore(testID!, newScore > (temp!.questions.count) ? temp!.questions.count : newScore)
            
            ProfileDataModel.sharedInstance.updateExperiencePoints(1, testXP!)
            
            AchievementDataModel.sharedInstance.updateProgress(forAchievementId: 3, increment: 1)
            
            BadgesDataModel.sharedInstance.updateStreak(1)
            
            if(newScore == temp!.questions.count){
                AchievementDataModel.sharedInstance.updateProgress(forAchievementId: 2, increment: 1)
            }
            
        }else{
            ProfileDataModel.sharedInstance.updateExperiencePoints(1, Int(Double(testXP ?? 0)*(0.1)))
        }
        
        
        destinationVC.collectionView.reloadData()
        
        
    }
    
}
