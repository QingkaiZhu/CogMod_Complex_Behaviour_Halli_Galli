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
        case.flip: return "flip"
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
    var score = 14
    var mood = Emotion.neutral
    var actState = actionState.idle
    // The ACT-R model
    var model = Model()
    
    init(_ modelName: String) {
        id = modelName
    }
    
    /// run the model until someone press the bell
    mutating func run() {
        // check last round status, if it's the begining of the game or someone just won the last round
        
        // check last round status, if some one just press the bell wrongly
    }
}
