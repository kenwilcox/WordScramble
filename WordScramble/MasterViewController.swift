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
      }
    } else {
      allWords = ["silkworm"]
    }
    
    startGame()
    
//    self.navigationItem.leftBarButtonItem = self.editButtonItem()
//    
//    let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
//    self.navigationItem.rightBarButtonItem = addButton
  }
  
  override func viewWillAppear(animated: Bool) {
    self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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

    // I think I actually prefer this syntax
//    let someAction = UIAlertAction(title: "Title", style: .Default) { (UIAlertAction) -> Void in
//      let answer = ac.textFields![0]
//      self.submitAnswer(answer.text!)
//    }
    
    let submitAction = UIAlertAction(title: "Submit", style: .Default) {
      [unowned self, ac] (action: UIAlertAction!) in
      let answer = ac.textFields![0]
      self.submitAnswer(answer.text!)
    }
//    ac.addAction(someAction)
    ac.addAction(submitAction)
    
    presentViewController(ac, animated: true, completion: nil)
  }
  
  func submitAnswer(answer: String) {
    let lowerAnswer = answer.lowercaseString
    
    if wordIsPossible(lowerAnswer) {
      if wordIsOriginal(lowerAnswer) {
        if wordIsReal(lowerAnswer) {
          objects.insert(answer, atIndex: 0)
          
          let indexPath = NSIndexPath(forRow: 0, inSection: 0)
          tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
      }
    }
  }
  
  func wordIsPossible(word: String) -> Bool {
    return true
  }
  
  func wordIsOriginal(word: String) -> Bool {
    return !objects.contains(word)
  }
  
  func wordIsReal(word: String) -> Bool {
    return true
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

