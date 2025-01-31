//
//  DictionaryViewController.swift
//  islearn
//
//  Created by Aastik Mehta on 25/12/24.
//

import UIKit
import AVKit
import AVFoundation

class DictionaryViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var videoView: UIView!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UITextView!
    var allWords: [Word] = WordDataModel.sharedInstance.fetchAllWords()
    var filteredWords: [Word] = []
    @IBOutlet weak var wordsSearchBar: UISearchBar!
    @IBOutlet weak var wordsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordsSearchBar.delegate = self
        wordsTableView.delegate = self
        wordsTableView.dataSource = self
        filteredWords = allWords
        //        wordsSearchBar.delegate = self
        loadDailyWord()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func loadDailyWord(){
        guard let wordOfTheDay = WordOfTheDay.sharedInstance.getWordOfTheDay() else {return}
        label2.text = wordOfTheDay.wordName
        label3.text = wordOfTheDay.wordDefinition
        let player1 = AVPlayer(url: URL(filePath: Bundle.main.path(forResource: wordOfTheDay.videoURL, ofType: "mp4")!))
        let layer1 = AVPlayerLayer(player: player1)
        layer1.frame = videoView.bounds
        videoView.layer.addSublayer(layer1)
        player1.play()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = wordsTableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let word = filteredWords[indexPath.row]
        content.text = word.wordName
        cell.contentConfiguration = content
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWordsDetail" , let indexPath = wordsTableView.indexPathForSelectedRow {
            let wordViewController = segue.destination as! wordsDetailViewController
            let selectedWord = filteredWords[indexPath.row]
            wordViewController.word = selectedWord
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredWords = allWords
        } else {
            filteredWords = allWords.filter { $0.wordName.lowercased().contains(searchText.lowercased()) }
        }
        wordsTableView.reloadData()
    }
    
    internal func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredWords = allWords
        wordsTableView.reloadData()
        searchBar.resignFirstResponder()
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)

    }
}
