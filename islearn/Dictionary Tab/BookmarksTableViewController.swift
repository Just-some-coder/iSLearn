//
//  BookmarksTableViewController.swift
//  islearn
//
//  Created by Aastik Mehta on 25/12/24.
//

import UIKit

class BookmarksTableViewController: UITableViewController {
    
    @IBOutlet weak var labelTemp: UILabel!
    
    var bookmarkedWords = BookMarkedWords.sharedInstance.getBookmarkedWords()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(bookmarkedWords.count > 0) {
            
            labelTemp.isHidden = true
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkedWords.count ;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmark", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let word = bookmarkedWords[indexPath.row]
        content.text = word.wordName
        content.secondaryText = word.wordDefinition
        cell.contentConfiguration = content
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBookmarkDetail" , let indexPath = tableView.indexPathForSelectedRow {
            let wordViewController = segue.destination as! DictionaryWordsViewController
            let selectedWord = bookmarkedWords[indexPath.row]
            wordViewController.word = selectedWord
        }
    }
}
