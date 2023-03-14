//
//  HalliGalliModel.swift
//  test
//
//  Created by P. Pintea on 2/15/23.
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

struct HGModel{
    let m1 = Model()
    let m2 = Model()
    let m3 = Model()
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
    var modelState: actionState = .idle
    var playerState: actionState = .idle
    
    // TODO: refer to the PDModel3 init is not necessary for Swift implementation
//    init() {
//        // TODO: Change model afterwards
//        model.loadModel(fileName: "rps")
//        model.run()
//    }
    
    var decks: PlayableDecks
    var cardsToDeal: Array<Card> = []
    
    init(playableDecks: PlayableDecks){
        decks = playableDecks // saving the playable decks into the model
        // model.loadModel(fileName: "rps")// TODO: Change model afterwards
        // model.run()
    }
    
    // Run the model
    mutating func run() {
        
    }
    
    // Reset the model
    mutating func reset(model: Model) {
        model.reset()
        modelState = .idle
        playerState = .idle
        modelScore = 14
        playerScore = 14
        modelMood = Emotion.neutral
        playerMood = Emotion.neutral
        run()
    }
    
    // TODO: ensure that this function is done properly
    mutating func flipFirstCard(ofPlayer deckName: String){
        if (deckName == "player"){
            print("Flipped card from player's Deck")
            if !decks.playerHasFlippedCard{
                decks.playerHasFlippedCard.toggle()
            }
            else if !decks.playerCards.isEmpty{
                cardsToDeal.append(decks.playerCards.removeFirst())
                print(decks.playerCards.count, cardsToDeal.count)
            }
        }
        else if (deckName == "model1"){
            print("Flipped card from model1's Deck")
            if !decks.modelHasFlippedCard1{
                decks.modelHasFlippedCard1.toggle()
            }
            else if !decks.modelCards1.isEmpty{
                cardsToDeal.append(decks.modelCards1.removeFirst())
            }
        }
        else if (deckName == "model2"){
            print("Flipped card from model2's Deck")
            if !decks.modelHasFlippedCard2{
                decks.modelHasFlippedCard2.toggle()
            }
            else if !decks.modelCards2.isEmpty{
                cardsToDeal.append(decks.modelCards2.removeFirst())
            }
        }
        else if (deckName == "model3"){
            print("Flipped card from model3's Deck")
            if !decks.modelHasFlippedCard3{
                decks.modelHasFlippedCard3.toggle()
            }
            else if !decks.modelCards3.isEmpty{
                cardsToDeal.append(decks.modelCards3.removeFirst())
            }
        }
    }
    // TODO: Complete bell press
    mutating func pressBell(by player: String){
        
    }
    
    // Check if this player/model is game over with 0 point
    mutating func isGameOver() {
        
    }
}
