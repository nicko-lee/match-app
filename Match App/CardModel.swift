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
        // Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        // Randomly generate pairs of cards - 8 pairs for 16 total cards
        for _ in 1...8 { // This just gives us a loop that loops 8x
            
            // Get a random number
            let randomNumber = arc4random_uniform(13) + 1
            
            // Log the number
            print(randomNumber)
            
            // Create the first card object
            let cardOne = Card()
            cardOne.imageName = "card\(randomNumber)"
            
            // Create the second card object
            let cardTwo = Card()
            cardTwo.imageName = "card\(randomNumber)"
            
            // Add created cards to card deck
            generatedCardsArray += [cardOne, cardTwo]
        }
        
        // TODO: Randomize the array
        
        
        // Return the array
        return generatedCardsArray
    }
}
