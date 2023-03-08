//
//  HalliGalliModel.swift
//  test
//
//  Created by P. Pintea on 2/15/23.
//

import Foundation

/// Player state:
/// idle: if it is my turn idle -> flip, if not my turn stay idle or idle -> press
/// flip: I am gonna to flip my card, notify the viewModel to update the view
/// press: I am gonna to press the bell
enum State: CustomStringConvertible{
    case press
    case flip
    case idle
    var description: String{
        switch self{
        case .press: return "press"
        case.flip: return "flip"
        case .idle: return "idle"
        }
    }
    static func findAction(_ actionString: String) -> State{
        switch actionString{
        case "press": return(.press)
        case "flip": return(.flip)
        default: return(.idle)
        }
    }
}

/// Emotions for the cat face near every player's card
// TODO: replace the emoji with cat face or other pics
enum Emotion: CustomStringConvertible {
    case happy
    case sad
    case neutral
    var description: String {
        switch self {
        case.happy: return "🥳"
        case.sad: return "😞"
        case.neutral: return "😐"
        }
    }
}

struct HGModel{
    let model = Model()
    /// Model variables
    // TODO: we should decide how to calculate the score
    /// Initiall, every player get 14 cards in total, the simplest way is to convert 1 card to 1 point.
    /// A player loses the game when the player has no card on the deck, that is to say the player's
    /// point decreases to 0
    var playerScore = 14
    var modelScore = 14
    var playerMood = Emotion.neutral
    var modelMood = Emotion.neutral
    // TODO: should we place the player and AI in the same model, since
    // we will have three AI models in the game while only 1 real player
    var modelState: State = .idle
    var playerState: State = .idle
    
    // TODO: refer to the PDModel3 init is not necessary for Swift implementation
//    init() {
//        // TODO: Change model afterwards
//        model.loadModel(fileName: "rps")
//        model.run()
//    }
    
    // Run the model
    mutating func run() {
        
    }
    
    // Reset the model
    mutating func reset() {
        model.reset()
        modelState = .idle
        playerState = .idle
        modelScore = 14
        playerScore = 14
        modelMood = Emotion.neutral
        playerMood = Emotion.neutral
        run()
    }
}
