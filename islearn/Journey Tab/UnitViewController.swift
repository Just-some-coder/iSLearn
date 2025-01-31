import UIKit
import AVKit
import AVFoundation

class UnitViewController: UIViewController {
    
    @IBOutlet weak var buttonTitle: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var completedButton: UIButton!
    
    var exercise: Exercise?
    var sectionTitle: String?
    
    var videoPlayer: AVPlayer?
    var videoPlayerLayer: AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        if let exercise = exercise, let sectionTitle = sectionTitle {
            buttonTitle.text = exercise.name
            navigationItem.title = sectionTitle
            
            if exercise.completed {
                completedButton.isEnabled = false
                completedButton.setTitle("Completed", for: .normal)
            }
        }
        setupVideoPlayer()
    }
    
    func setupVideoPlayer() {
        guard videoPlayer == nil else { return }
        
        videoPlayer = AVPlayer()
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        
        guard let videoPlayerLayer = videoPlayerLayer else { return }
        
        videoPlayerLayer.videoGravity = .resizeAspectFill
        videoPlayerLayer.frame = videoView.bounds
        videoView.layer.addSublayer(videoPlayerLayer)
            
            if let videoPath = Bundle.main.path(forResource: "holi", ofType: "mp4") {
                let videoURL = URL(fileURLWithPath: videoPath)
                videoPlayer = AVPlayer(url: videoURL)
                videoPlayerLayer.player = videoPlayer
                videoPlayer?.play()
            }
        }
    
    @IBAction func markAsCompletedTapped(_ sender: UIButton) {
        guard let exercise = exercise, let sectionTitle = sectionTitle else {
            return
        }
        if exercise.completed {
            return
        }
        
        JourneyDataModel.shared.completeExercise(sectionTitle: sectionTitle, exerciseName: exercise.name)
        sender.setTitle("Completed", for: .normal)
        sender.isEnabled = false
        
        if let section = JourneyDataModel.shared.journey.section.first(where: { $0.title == sectionTitle }) {
            if let exerciseIndex = section.exercises.firstIndex(where: { $0.name == exercise.name }) {
                if exerciseIndex + 1 < section.exercises.count {
                    let nextButton = sender.superview?.viewWithTag(exerciseIndex + 1) as? UIButton
                    nextButton?.isEnabled = true
                    nextButton?.backgroundColor = sectionTitle == "Alphabets" ? .themeColor : .red
                }
                
            }
            BadgesDataModel.sharedInstance.updateStreak(1)
            AchievementDataModel.sharedInstance.updateProgress(forAchievementId: 1, increment: 1)
            ProfileDataModel.sharedInstance.updateNumberOfWordsLearned(1)
            
        }
        
        
        let alert = UIAlertController(title: "Completed", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
}
