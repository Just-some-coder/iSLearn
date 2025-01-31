import UIKit
import AVKit
import AVFoundation

class wordsDetailViewController: UIViewController {
    
    var word: Word?
    
    @IBOutlet weak var wordNameLabel: UILabel!
    let videoCapture = VideoCapture()
    
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!
    @IBOutlet weak var wordDescriptionLabel: UILabel!
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var gestureView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let word = word {
            
            
            wordDescriptionLabel.text = word.wordDefinition
        }
        
        self.title = word?.wordName
        loadDailyWord()
        let isBookmarked = BookMarkedWords.sharedInstance.getBookmarkedWords().contains(word!)
        bookmarkButton.image = UIImage(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
    }
    
    private func setupVideoPreview() {
        videoCapture.startCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: videoCapture.captureSession)
        guard let previewLayer = previewLayer else { return }
        //        previewLayer.frame = gestureView.bounds
        gestureView.layer.addSublayer(previewLayer)
        previewLayer.frame = gestureView.frame
    }
    
    func loadDailyWord(){
        
        let player1 = AVPlayer(url: URL(filePath: Bundle.main.path(forResource: "holi", ofType: "mp4")!))
        
        let layer1 = AVPlayerLayer(player: player1)
        
        layer1.frame = videoView.frame //
        
        videoView.layer.addSublayer(layer1)
        
        player1.play()
    }
    
    @IBAction func bookmarkBtnTapped(_ sender: UIBarButtonItem) {
        
        
        BookMarkedWords.sharedInstance.toggleBookmarkedWords(word!);
        
        // Update the button's image based on the bookmark status
        let isBookmarked = BookMarkedWords.sharedInstance.getBookmarkedWords().contains(word!)
        
        bookmarkButton.image = UIImage(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
    }
}
