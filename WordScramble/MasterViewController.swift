//
//  MasterViewController.swift
//  WordScramble
//
//  Created by Kenneth Wilcox on 10/29/15.
//  Copyright © 2015 Kenneth Wilcox. All rights reserved.
//

import UIKit
import GameplayKit

class MasterViewController: UITableViewController {
  
  var objects = [String]()
  var allWords = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "promptForAnswer")
    
    if let startWordsPath = NSBundle.mainBundle().pathForResource("start", ofType: "txt") {
      if let startWords = try? String(contentsOfFile: startWordsPath, usedEncoding: nil) {
        allWords = startWords.componentsSeparatedByString("\n")
      } else {
        loadDefaultWords()
      }
    } else {
      loadDefaultWords()
    }
    
    startGame()
  }
  
  override func viewWillAppear(animated: Bool) {
    self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func loadDefaultWords() {
    allWords = ["silkworm"]
  }
  
  func startGame() {
    allWords = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(allWords) as! [String]
    title = allWords[0]
    objects.removeAll(keepCapacity: true)
    tableView.reloadData()
  }
  
  func promptForAnswer() {
    let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .Alert)
    ac.addTextFieldWithConfigurationHandler(nil)

    let submitAction = UIAlertAction(title: "Submit", style: .Default) {
      [unowned self, ac] (action: UIAlertAction!) in
      let answer = ac.textFields![0]
      self.submitAnswer(answer.text!)
    }
    ac.addAction(submitAction)
    
    presentViewController(ac, animated: true, completion: nil)
  }
  
  func submitAnswer(answer: String) {
    let lowerAnswer = answer.lowercaseString
    var error = ErrorAnswer.None
    
    if !wordIsNotAnswer(lowerAnswer) {error.insert(.WordIsAnswer)}
    if !wordIsPossible(lowerAnswer) {error.insert(.WordIsPossible)}
    if !wordIsOriginal(lowerAnswer) {error.insert(.WordIsOriginal)}
    if !wordIsReal(lowerAnswer) {error.insert(.WordIsReal)}
    
    
    switch(error) {
    case _ where error.contains(.WordIsOriginal): showErrorMessage("Word used already", errorMessage: "Be more original!")
    case _ where error.contains(.WordIsPossible): showErrorMessage("Word not possible", errorMessage: "You can't spell that word from '\(title!.lowercaseString)'!")
    case _ where error.contains(.WordIsAnswer): showErrorMessage("Word is the clue", errorMessage: "You can't use the same word as the clue!")
    case _ where error.contains(.WordIsReal): showErrorMessage("Word not recognized", errorMessage: "You can't just make them up, you know!")
      // If you made if this far you can add a word
    default:
      objects.insert(answer, atIndex: 0)
      let indexPath = NSIndexPath(forRow: 0, inSection: 0)
      tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
  }
  
  func showErrorMessage(errorTitle: String, errorMessage: String) {
    let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .Alert)
    ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    presentViewController(ac, animated: true, completion: nil)
  
  }
  
  func wordIsNotAnswer(word: String) -> Bool {
    return word.lowercaseString != title!.lowercaseString
  }
  
  func wordIsPossible(word: String) -> Bool {
    var tempWord = title!.lowercaseString
    
    for letter in word.characters {
      if let pos = tempWord.rangeOfString(String(letter)) {
        tempWord.removeAtIndex(pos.startIndex)
      } else {
        return false
      }
    }
    return true
  }
  
  func wordIsOriginal(word: String) -> Bool {
    return !objects.contains(word)
  }
  
  func wordIsReal(word: String) -> Bool {
    let checker = UITextChecker()
    let range = NSMakeRange(0, word.characters.count)
    let misspelledRange = checker.rangeOfMisspelledWordInString(word, range: range, startingAt: 0, wrap: false, language: "en")
    
    return misspelledRange.location == NSNotFound
  }
  
  // MARK: - Table View
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return objects.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    
    let object = objects[indexPath.row]
    cell.textLabel!.text = object
    return cell
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      objects.removeAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
  }
  
  
}

