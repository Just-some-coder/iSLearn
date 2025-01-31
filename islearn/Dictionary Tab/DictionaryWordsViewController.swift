//
//  DictionaryWordsViewController.swift
//  islearn
//
//  Created by Aastik Mehta on 25/12/24.
//

import UIKit
import AVKit
import AVFoundation

class DictionaryWordsViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var wordNameLabel: UILabel!
    @IBOutlet weak var wordDescriptionLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!
    var word: Word?
    @IBOutlet weak var gestureCameraView: UIView!
    let videoCapture = VideoCapture()
    var previewLayer : AVCaptureVideoPreviewLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let word = word {
//            wordNameLabel.text = word.wordName
            wordDescriptionLabel.text = word.wordDefinition
                }
        self.title = word?.wordName
        loadDailyWord()
        let isBookmarked = BookMarkedWords.sharedInstance.getBookmarkedWords().contains(word!)
        bookmarkButton.image = UIImage(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
        self.title = word?.wordName
    }
    
    private func setupVideoPreview() {
        videoCapture.startCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: videoCapture.captureSession)
        guard let previewLayer = previewLayer else { return }
        gestureCameraView.layer.addSublayer(previewLayer)
        previewLayer.frame = gestureCameraView.frame
    }
   
    
    func loadDailyWord(){
        let player1 = AVPlayer(url: URL(filePath: Bundle.main.path(forResource: "holi", ofType: "mp4")!))
        let layer1 = AVPlayerLayer(player: player1)
      layer1.frame = videoView.frame
       videoView.layer.addSublayer(layer1)
        player1.play()
    }
    
    @IBAction func bookmarkBtnTapped(_ sender: UIBarButtonItem) {
        BookMarkedWords.sharedInstance.toggleBookmarkedWords(word!);
        let isBookmarked = BookMarkedWords.sharedInstance.getBookmarkedWords().contains(word!)
        bookmarkButton.image = UIImage(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
    }
}
