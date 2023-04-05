//
//  HalliGalliModel.swift
//  test
//
//  Created by P. Pintea on 2/15/23.
//

import Foundation

enum bellPressed: CustomStringConvertible {
    case rightPress
    case wrongPress
    case nonPress
    var description: String {
        switch self {
        case .rightPress: return "rightPress"
        case .wrongPress: return "wrongPress"
        case .nonPress: return "nonPress"
        }
    }
}

struct HGModel{
    var m1 = modelPlayer("model1")
    var m2 = modelPlayer("model2")
    var m3 = modelPlayer("model3")
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
    // The game will starts with the real player
    var playerInTurn: String = "player"
    // If someone just pressed the bell
    var pressStatus = bellPressed.nonPress
    // If the game is over
    var gameOver: Bool = false
    
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
        if isNewRround(){
            m1.runFromBegining(turnOf: playerInTurn)
            m2.runFromBegining(turnOf: playerInTurn)
            m3.runFromBegining(turnOf: playerInTurn)
        } else {
            m1.runFromInteruption(turnOf: playerInTurn)
            m2.runFromInteruption(turnOf: playerInTurn)
            m3.runFromInteruption(turnOf: playerInTurn)
        }
    }
    // Update the goal once someone just flipped a new card
    mutating func updateGoal(turnOf playerInTurn: String) {
        m1.updateGoal(turnOf: playerInTurn)
        m2.updateGoal(turnOf: playerInTurn)
        m3.updateGoal(turnOf: playerInTurn)
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
    
    // Start the game in clock wise from the playerInTurn
    // TODO: if a player loses the game, remove the player from the schduleList, shall we keep this list out of this function, since it might be useful for other funcs as weel
    mutating func turnSchedule() {
        let scheduleList: Array<String> = ["player", "model1", "model2", "model3"]
        let i = scheduleList.firstIndex(of: playerInTurn)
        while pressStatus != bellPressed.rightPress && !gameOver {
            
        }
    }
    
    // TODO: ensure that this function is done properly
    mutating func flipFirstCard(ofPlayer deckName: String){
        if (deckName == "player"){
            print("Flipped card from player's Deck")
            // If all the cards on this player's deck is face-down, flip the top card
            if !decks.playerHasFlippedCard{
                decks.playerHasFlippedCard.toggle()
            }
            // Remove the current top face-up card and append it to cardsToDeal(prize deck), then flip the next card automatically
            else if !decks.playerCards.isEmpty{
                cardsToDeal.append(decks.playerCards.removeFirst())
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
        updateGoal(turnOf: deckName)
        let _ = isGameOver()
    }
    
    
    // TODO: Ensure bell press is done properly
    mutating func pressBell(by player: String){
        var correctPress:Bool = false// Declaring flag for correct press
        var sumPerClass:Dictionary = ["a" : 0, "b" : 0, "c" : 0, "d" : 0]//Declaring dict for computing sums
        
        //Computing the sums for all the Classes/Figures present in on the table
        if (!decks.playerCards.isEmpty && decks.playerHasFlippedCard){
            sumPerClass[decks.playerCards[0].figureClass]! += decks.playerCards[0].figuresNo
        }
        
        if (!decks.modelCards1.isEmpty && decks.modelHasFlippedCard1){
            sumPerClass[decks.modelCards1[0].figureClass]! += decks.modelCards1[0].figuresNo
        }
        
        if (!decks.modelCards2.isEmpty && decks.modelHasFlippedCard2){
            sumPerClass[decks.modelCards2[0].figureClass]! += decks.modelCards2[0].figuresNo
        }
        
        if (!decks.modelCards3.isEmpty && decks.modelHasFlippedCard3){
            sumPerClass[decks.modelCards3[0].figureClass]! += decks.modelCards3[0].figuresNo
        }
        
        
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
            if decks.playerHasFlippedCard{
                decks.playerHasFlippedCard.toggle()
            }
            if decks.modelHasFlippedCard1{
                decks.modelHasFlippedCard1.toggle()
            }
            if decks.modelHasFlippedCard2{
                decks.modelHasFlippedCard2.toggle()
            }
            if decks.modelHasFlippedCard3{
                decks.modelHasFlippedCard3.toggle()
            }
            
            
            if !decks.playerCards.isEmpty{
                cardsToDeal.append(decks.playerCards.removeFirst())
            }
            else{let _ = isGameOver()}
            
            if !decks.modelCards1.isEmpty{
                cardsToDeal.append(decks.modelCards1.removeFirst())
            }
            else{let _ = isGameOver()}
            
            if !decks.modelCards2.isEmpty{
                cardsToDeal.append(decks.modelCards2.removeFirst())
            }
            else{let _ = isGameOver()}
            
            if !decks.modelCards3.isEmpty{
                cardsToDeal.append(decks.modelCards3.removeFirst())
            }
            else{let _ = isGameOver()}
        }
        else{
            print("Wrong Press")
        }
        
        // Checking which player/model pressed the bell
        if (player == "player"){
            // If the player/model is wrong it losses between 1 and 3 cards from the back and deals them to the others
            if !correctPress{
                print("Player lost 3 cards,dealt to others")
                
                // Cards are dealt if there are still cards in the deck, otherwise a check for game over is performed
                if !decks.playerCards.isEmpty{
                    decks.modelCards1.append(decks.playerCards.removeLast())
                }
                else{let _ = isGameOver()}
                
                if !decks.playerCards.isEmpty{
                    decks.modelCards2.append(decks.playerCards.removeLast())
                }
                else{let _ = isGameOver()}
                
                if !decks.playerCards.isEmpty{
                    decks.modelCards3.append(decks.playerCards.removeLast())
                }
                else{let _ = isGameOver()}
            }
            // Otherwise the player is correct and it gains all cards from the array with cards that need to dealt
            // and resetting the cards to be dealt array back to nil
            else{
                decks.playerCards.append(contentsOf: cardsToDeal)
                cardsToDeal.removeAll()
                playerInTurn = "player"
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
                else{let _ = isGameOver()}
                
                if !decks.modelCards1.isEmpty{
                    decks.modelCards3.append(decks.modelCards1.removeLast())
                }
                else{let _ = isGameOver()}
                
                if !decks.modelCards1.isEmpty{
                    decks.playerCards.append(decks.modelCards1.removeLast())
                }
                else{let _ = isGameOver()}
                
                
                
            }
            // Otherwise the player is correct and it gains all cards from the array with cards that need to dealt
            // and resetting the cards to be dealt array back to nil
            else{
                decks.modelCards1.append(contentsOf: cardsToDeal)
                cardsToDeal.removeAll()
                playerInTurn = "model1"
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
                else{let _ = isGameOver()}
                
                if !decks.modelCards2.isEmpty{
                    decks.playerCards.append(decks.modelCards2.removeLast())
                }
                else{let _ = isGameOver()}
                
                if !decks.modelCards2.isEmpty{
                    decks.modelCards1.append(decks.modelCards2.removeLast())
                }
                else{let _ = isGameOver()}
            }
            // Otherwise the player is correct and it gains all cards from the array with cards that need to dealt
            // and resetting the cards to be dealt array back to nil
            else{
                decks.modelCards2.append(contentsOf: cardsToDeal)
                cardsToDeal.removeAll()
                playerInTurn = "model2"
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
                else{let _ = isGameOver()}
                
                if !decks.modelCards3.isEmpty{
                    decks.modelCards1.append(decks.modelCards3.removeLast())
                }
                else{let _ = isGameOver()}
                
                if !decks.modelCards3.isEmpty{
                    decks.modelCards2.append(decks.modelCards3.removeLast())
                }
                else{let _ = isGameOver()}
            }
            // Otherwise the player is correct and it gains all cards from the array with cards that need to dealt
            // and resetting the cards to be dealt array back to nil
            else{
                decks.modelCards3.append(contentsOf: cardsToDeal)
                cardsToDeal.removeAll()
                playerInTurn = "model3"
            }
        }
        
    }
    // Check if this player loses the game
    // TODO: finish this
    mutating func isPlayerAlive(ofPlayer deckName: String) -> Bool {return false}
    
    // Check if this player/model is game over with 0 point
    mutating func isGameOver() -> Bool {
        if decks.playerCards.isEmpty{
            gameOver = true
            print("Player has lost")
        }
        else if decks.modelCards1.isEmpty && decks.modelCards2.isEmpty && decks.modelCards3.isEmpty{
            print("Player won")
            gameOver = true
        }
        return gameOver
    }
    
    // Check if it is the begining of a round(begining of the game or someone just won a round by a successfull pressing)
    func isNewRround() -> Bool {
        return !decks.modelHasFlippedCard1 && !decks.modelHasFlippedCard2 && !decks.modelHasFlippedCard3 && !decks.playerHasFlippedCard
    }
    
    // Append all the top and face-up cards to this array
    func getActiveCards() -> Array<Card> {
        var activeCards: Array<Card> = []
        if decks.playerHasFlippedCard{
            activeCards.append(decks.playerCards[0])
        }
        if decks.modelHasFlippedCard1{
            activeCards.append(decks.modelCards1[0])
        }
        if decks.modelHasFlippedCard2{
            activeCards.append(decks.modelCards2[0])
        }
        if decks.modelHasFlippedCard3{
            activeCards.append(decks.modelCards3[0])
        }
        return activeCards
    }
}
