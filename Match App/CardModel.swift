//
//  CardModel.swift
//  Match App
//
//  Created by Nicko Lee on 3/12/20.
//  Copyright © 2020 Nicko Lee. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        // Declare an array to store numbers we've already generated
        var generatedNumbersArray = [Int]()

        // Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        // Randomly generate pairs of cards - 8 pairs for 16 total cards
        while generatedNumbersArray.count < 8 { 
            
            // Get a random number
            let randomNumber = arc4random_uniform(13) + 1
            
            // Ensure that the random number isn't one we already have
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                // Log the number
                print(randomNumber)
                
                // Store the number into the generatedNumbersArray
                generatedNumbersArray.append(Int(randomNumber))
                
                // Create the first card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                
                // Create the second card object
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                
                // Add created cards to card deck
                generatedCardsArray += [cardOne, cardTwo]
            }
            
        }
        
        // Randomize the array
        for i in 0...generatedCardsArray.count - 1 {
            // Find a random index to swap with
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            
            // Swapping code to swap the 2 cards
            let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[randomNumber]
            generatedCardsArray[randomNumber] = temporaryStorage
        }
        
        // Return the array
        return generatedCardsArray
    }
}
