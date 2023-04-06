//
//  Players.swift
//  This file contains the Sturct for the model player which is
//  response for when to switch the actionState i.e. when to call
//  pressBell() or flipFirstCard()
//
//  Created by Q. Zhu on 17/03/2023.
//

import Foundation

/// Player action state:
/// idle: if it is my turn idle -> flip, if not my turn stay idle or idle -> press
/// flip: I am gonna to flip my card, notify the viewModel to update the view
/// press: I am gonna to press the bell
enum actionState: CustomStringConvertible{
    case press
    case flip
    case idle
    var description: String{
        switch self{
        case .press: return "press"
        case .flip: return "flip"
        case .idle: return "idle"
        }
    }
    static func findAction(_ actionString: String) -> actionState {
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


struct modelPlayer {
    var id: String
    // TODO: we should decide how to calculate the score
    /// Initiall, every player get 14 cards in total, the simplest way is to convert 1 card to 1 point.
    /// A player loses the game when the player has no card on the deck, that is to say the player's
    /// point decreases to 0
    var score = 14
    var mood = Emotion.neutral
    var actState = actionState.idle
    // The ACT-R model
    var model = Model()
    
    init(_ modelName: String) {
        id = modelName
    }
    
    /// run the model until someone press the bell
    /// If it's the begining of the game or someone just won the last round
    mutating func runFromBegining(turnOf playerInTurn: String) {
        // Basic strategy: set the fruit class of the newly flipped card as goal and check if there are five of this kind of fruit
        
    }
    /// If some one just press the bell wrongly, there are already four face-up cards on the deck,
    /// but none of the four fruit class has five fruits,
    mutating func runFromInteruption(turnOf playerInTurn: String) {
        
    }
    
    /// Update the goal every time when a new card is flipped
    mutating func updateGoal(turnOf playerInTurn: String){
        
    }
}
