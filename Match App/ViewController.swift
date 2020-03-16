//
//  ViewController.swift
//  Match App
//
//  Created by Nicko Lee on 3/12/20.
//  Copyright © 2020 Nicko Lee. All rights reserved.
//

import UIKit

// A constant I can reuse and easily just change from one place otherwise will have to change this in 2 places each time I change game time
let gameTimeSetting: Float = 10 * 3000 // 30 seconds (0.5 min) expressed in ms

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    // We make this a type of IndexPath cos that is what the CollectionView gives us when the user selects a cell
    var firstFlippedCardIndex:IndexPath?
    
    var timer: Timer? // it is optional now - the reason for that is we want to create the actual timer object in viewDidLoad
    
    var milliseconds: Float = gameTimeSetting
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Call the getCards method of the CardModel
        cardArray = model.getCards()
        
        // Restart game
        restartGame()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Create timer object
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    // This method gets called when the view is presented to the user
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.playSound(.shuffle)
    }

    // MARK: - new section for Timer Methods
    @objc func timerElapsed() {
        // Each time this method fires deduct a millisecond from our counter
        milliseconds -= 1
        
        // Convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        // Set timer label
        timerLabel.text = "Time remaining: \(seconds)"
        
        // Address reaching 0 on timer cos currently it goes into negative
        if milliseconds <= 0 {
            // Stop the timer
            timer?.invalidate() // this is the way to stop the timer
            timerLabel.textColor = UIColor.red
            
            // Check if there are any cards unmatched
            checkGameEnded()
        }
    }
    
    // MARK: - UICollectionView Protocol Methods
    
    // This is a method the CollectionView will call to ask its delegate the number of items it needs to display
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    // This is called by CV to ask its delegate (i.e. this VC class/self) which is its data source, for new data to display
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a CardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Get the card that the collection view is trying to display
        let card = cardArray[indexPath.row]
        
        // Set that card for the cell
        cell.setCard(card)
        
        return cell
    }
    
    // Now we are up to the second protocol we need to implement. This event happens when the user taps on a cell in the grid
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check if there is any time left
        if milliseconds <= 0 {
            return // it exists the entire method which stops the user from selecting any cards when the time is up
        }
        
        // Get the cell that the user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // Get the card that the user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
            // Flip the card (only allowed if satisfies the above conditions)
            cell.flip()
            
            // Play the flip sound
            SoundManager.playSound(.flip)
            
            // Set the flip status of the card
            card.isFlipped = true
            
            // Determine if it is the first card or second card that is flipped over
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            }
            else {
                // This is the second card being flipped
                
                // TODO: Perform the matching logic
                checkForMatches(indexPath)
            }
        }
    } // End of didSelectItemAt method
    
    // MARK: - Game Logic Methods
    func checkForMatches(_ secondFlippedCardIndex: IndexPath) {
        // Get the cells for the two cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Get the cards for the two cards that were revealed
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        // Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            // It's a match
            
            // Play sound
            SoundManager.playSound(.match)
            
            // Set the statuses of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Remove the cards from the grid
            cardOneCell?.remove() // this is called optional chaining
            cardTwoCell?.remove() // so if it is nil it won't call the method. This helps protect ourselves from crashes
            
            // Check if there are any cards left unmatched
            checkGameEnded()
        }
        else {
            // It's not a match
            
            // Play sound
            SoundManager.playSound(.nomatch)
            
            // Set the statuses of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        // Tell the collectionView to reload the cell of the first card if it is nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        // Reset the property that tracks the first card flipped
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded() {
        // Determine if there are any cards unmatched
        var isWon = true
        
        for card in cardArray {
            if card.isMatched == false {
                isWon = false // if I even find one card that is unmatched then break out of loop. Means user hasn't won yet
                break
            }
        }
        
        // Messaging variables
        var title = ""
        var message = ""
        
        // If not, then user has won, stop the timer
        if isWon == true {
            if milliseconds > 0 {
                timer?.invalidate()
            }
            
            title = "Congratulations!"
            message = "You've won"
        } else {
            // If there are unmatched cards, check if there's any time left
            if milliseconds > 0 {
                return
            }
            
            title = "Game Over"
            message = "You've lost"
        }
        
        // Show won/lost messaging
        showAlert(title, message)
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let // Add second button - my own additional feature
        alertAction = UIAlertAction(title: "Play again!", style: .default, handler: {(action) in
            // Respond to user selection of the action.
            self.viewDidLoad()
        })
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func restartGame() {
        // Reset collectionView - so user can replay game from fresh start
        collectionView.reloadData()
        
        // Restart timer
        milliseconds = gameTimeSetting
    }
    
}

