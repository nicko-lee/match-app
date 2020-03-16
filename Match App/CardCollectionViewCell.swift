//
//  CardCollectionViewCell.swift
//  Match App
//
//  Created by Nicko Lee on 3/14/20.
//  Copyright © 2020 Nicko Lee. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    // Keep track of which card this cell is supposed to display
    
    var card: Card? // optional as initially this prop will be nil
    
    func setCard(_ card: Card) {
        // Keep track of the card that gets passed in
        self.card = card // we used self.card here to differentiate as they have same var name
        
        if card.isMatched == true {
            // If the card has been matched, then make the image views invisible
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return // this will exit the method and not run any of the code below
        } else {
            // If the card hasn't been matched, then make the image views visible
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        frontImageView.image = UIImage(named: card.imageName)
        
        // Determine if the card is in a flipped up state or a flip down state
        if card.isFlipped == true {
            // Make sure the frontImageView is on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        } else {
            // Make sure the backImageView is on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
    }
    
    func flip() {
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack() {
        
        // This dispatch queue thing lets u introduce some delay so the user can see what is happening
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    func remove() {
        // Removes both imageViews from being visible
        backImageView.alpha = 0 // alpha sets opacity so can make it invisible
        // Animate it
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
        
    }
}
