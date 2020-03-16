//
//  SoundManager.swift
//  Match App
//
//  Created by Nicko Lee on 3/16/20.
//  Copyright © 2020 Nicko Lee. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer: AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    static func playSound(_ effect: SoundEffect) {
        var soundFilename = ""
        
        
        // Determine which sound effect we want to play and set the appropriate filename
        switch effect {
            
        case .flip:
            soundFilename = "cardflip"
            
        case .shuffle:
            soundFilename = "shuffle"
            
        case .match:
            soundFilename = "dingcorrect"
            
        case .nomatch:
            soundFilename = "dingwrong"
            
        // No need the default case cos we are switching on an enumeration so you will never need the default case
        }
        
        // Get path to the sound file inside the bundle
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Couldn't find sound file \(soundFilename) in the bundle")
            return
        }
        
        // Create a URL object from this string path. Reason is cos the AV Audio Player class that actually plays the sound needs a URL object. So this is often what u will do in coding. You will import some library with classes. And u will figure out to use this class u need certain objects and then u will call init methods that return the objects u need
        let soundURL = URL(fileURLWithPath: bundlePath!) // it is ok to force unwrap this optional since we have the guard statement above. So if it comes here we can be sure bundlePath isn't nil
        
        do {
            // Create audio player object (or try to)
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            // If all else is going smoothly here u can then play the sound
            audioPlayer?.play()
        } catch {
            // If the try above fails it will come into this catch block
            // Couldn't create audio player object, log the error
            print("Couldn't create the audio player object for sound file \(soundFilename)")
        }
    }
}
