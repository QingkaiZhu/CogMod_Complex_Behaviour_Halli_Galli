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
            else{isGameOver()}
        }
        else if (deckName == "model1"){
            print("Flipped card from model1's Deck")
            if !decks.modelHasFlippedCard1{
                decks.modelHasFlippedCard1.toggle()
            }
            else if !decks.modelCards1.isEmpty{
                cardsToDeal.append(decks.modelCards1.removeFirst())
            }
            else{isGameOver()}
        }
        else if (deckName == "model2"){
            print("Flipped card from model2's Deck")
            if !decks.modelHasFlippedCard2{
                decks.modelHasFlippedCard2.toggle()
            }
            else if !decks.modelCards2.isEmpty{
                cardsToDeal.append(decks.modelCards2.removeFirst())
            }
            else{isGameOver()}
        }
        else if (deckName == "model3"){
            print("Flipped card from model3's Deck")
            if !decks.modelHasFlippedCard3{
                decks.modelHasFlippedCard3.toggle()
            }
            else if !decks.modelCards3.isEmpty{
                cardsToDeal.append(decks.modelCards3.removeFirst())
            }
            else{isGameOver()}
        }
    }
    
    
    // TODO: Ensure bell press is done properly
    mutating func pressBell(by player: String){
        var correctPress:Bool = false// Declaring flag for correct press
        var sumPerClass:Dictionary = ["a" : 0, "b" : 0, "c" : 0, "d" : 0]//Declaring dict for computing sums
        
        //Computing the sums for all the Classes/Figures present in on the table
        sumPerClass[decks.playerCards[0].figureClass]! += decks.playerCards[0].figuresNo
        sumPerClass[decks.modelCards1[0].figureClass]! += decks.modelCards1[0].figuresNo
        sumPerClass[decks.modelCards2[0].figureClass]! += decks.modelCards2[0].figuresNo
        sumPerClass[decks.modelCards3[0].figureClass]! += decks.modelCards3[0].figuresNo
        
        // If one of the classes has the sum 5 then it is a correct press
        for total in sumPerClass.values{
            if (total == 5){
                correctPress = true
                print("Correct Press")
            }
        }
        
        // If it is a correct press all cards are turned (back of card showing)
        // and the cards that were present on the table are added to the array with the cards that need to be dealt to the winner
        if correctPress{
            decks.playerHasFlippedCard.toggle()
            decks.modelHasFlippedCard1.toggle()
            decks.modelHasFlippedCard2.toggle()
            decks.modelHasFlippedCard3.toggle()
            
            if !decks.playerCards.isEmpty{
                cardsToDeal.append(decks.playerCards.removeFirst())
            }
            else{isGameOver()}
            
            if !decks.modelCards1.isEmpty{
                cardsToDeal.append(decks.modelCards1.removeFirst())
            }
            else{isGameOver()}
            
            if !decks.modelCards2.isEmpty{
                cardsToDeal.append(decks.modelCards2.removeFirst())
            }
            else{isGameOver()}
            
            if !decks.modelCards3.isEmpty{
                cardsToDeal.append(decks.modelCards3.removeFirst())
            }
            else{isGameOver()}
        }
        else{
            print("Wrong Press")
        }
        
        // Checking which player/model pressed the bell
        if (player == "player"){
            // If the player/model is wrong it losses 3 cards from the back and deals them to the others
            if !correctPress{
                print("Player lost 3 cards,dealt to others")
                
                // Cards are dealt if there are still cards in the deck, otherwise a check for game over is performed
                if !decks.playerCards.isEmpty{
                    decks.modelCards1.append(decks.playerCards.removeLast())
                }
                else{isGameOver()}
                
                if !decks.playerCards.isEmpty{
                    decks.modelCards2.append(decks.playerCards.removeLast())
                }
                else{isGameOver()}
                
                if !decks.playerCards.isEmpty{
                    decks.modelCards3.append(decks.playerCards.removeLast())
                }
                else{isGameOver()}
            }
            // Otherwise the player is correct and it gains all cards from the array with cards that need to dealt
            // and resetting the cards to be dealt array back to nil
            else{
                decks.playerCards.append(contentsOf: cardsToDeal)
                cardsToDeal.removeAll()
            }
        }
        else if (player == "model1"){
            // If the player/model is wrong it losses 3 cards from the back and deals them to the others
            if !correctPress{
                print("Model1 lost 3 cards,dealt to others")
                // Cards are dealt if there are still cards in the deck otherwise, a check for game over is performed
                if !decks.modelCards1.isEmpty{
                    decks.modelCards2.append(decks.modelCards1.removeLast())
                }
                else{isGameOver()}
                
                if !decks.modelCards1.isEmpty{
                    decks.modelCards3.append(decks.modelCards1.removeLast())
                }
                else{isGameOver()}
                
                if !decks.modelCards1.isEmpty{
                    decks.playerCards.append(decks.modelCards1.removeLast())
                }
                else{isGameOver()}
                
                
                
            }
            // Otherwise the player is correct and it gains all cards from the array with cards that need to dealt
            // and resetting the cards to be dealt array back to nil
            else{
                decks.modelCards1.append(contentsOf: cardsToDeal)
                cardsToDeal.removeAll()
            }
        }
        else if (player == "model2"){
            // If the player/model is wrong it losses 3 cards from the back and deals them to the others
            if !correctPress{
                print("Model2 lost 3 cards,dealt to others")
                // Cards are dealt if there are still cards in the deck, otherwise a check for game over is performed
                if !decks.modelCards2.isEmpty{
                    decks.modelCards3.append(decks.modelCards2.removeLast())
                }
                else{isGameOver()}
                
                if !decks.modelCards2.isEmpty{
                    decks.playerCards.append(decks.modelCards2.removeLast())
                }
                else{isGameOver()}
                
                if !decks.modelCards2.isEmpty{
                    decks.modelCards1.append(decks.modelCards2.removeLast())
                }
                else{isGameOver()}
            }
            // Otherwise the player is correct and it gains all cards from the array with cards that need to dealt
            // and resetting the cards to be dealt array back to nil
            else{
                decks.modelCards2.append(contentsOf: cardsToDeal)
                cardsToDeal.removeAll()
            }
        }
        else if (player == "model3"){
            // If the player/model is wrong it losses 3 cards from the back and deals them to the others
            if !correctPress{
                print("Model3 lost 3 cards,dealt to others")
                // Cards are dealt if there are still cards in the deck, otherwise a check for game over is performed
                if !decks.modelCards3.isEmpty{
                    decks.playerCards.append(decks.modelCards3.removeLast())
                }
                else{isGameOver()}
                
                if !decks.modelCards3.isEmpty{
                    decks.modelCards1.append(decks.modelCards3.removeLast())
                }
                else{isGameOver()}
                
                if !decks.modelCards3.isEmpty{
                    decks.modelCards2.append(decks.modelCards3.removeLast())
                }
                else{isGameOver()}
            }
            // Otherwise the player is correct and it gains all cards from the array with cards that need to dealt
            // and resetting the cards to be dealt array back to nil
            else{
                decks.modelCards3.append(contentsOf: cardsToDeal)
                cardsToDeal.removeAll()
            }
        }
        
    }
    
    // Check if this player/model is game over with 0 point
    mutating func isGameOver() {
        if decks.playerCards.isEmpty{
            print("Player has lost")
        }
        else if decks.modelCards1.isEmpty && decks.modelCards2.isEmpty && decks.modelCards3.isEmpty{
            print("Player won")
        }
    }
}