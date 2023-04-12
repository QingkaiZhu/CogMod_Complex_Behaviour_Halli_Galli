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
    //static variables to be used to build the game
    let playersNo: Int = 4 // dictates number of players
    let cardsNo: Int = 56 // dictates number of cards
    // dictates how many replicas of a card there should be, the index of the array
    // dictates how many figures should the replica have
    static let cardReplicas: [Int] = [5, 3, 3, 2, 1]
    static let cardFigures: [String] = ["apple", "avocado", "blueberry", "orange"] // dictates figures that will be on the cards
    static let cardClasses: [String] = ["a", "b", "c", "d"] // dictates the class of the card, each element relates to one figure
    var decks: PlayableDecks
    var priorActiveCards: [Card] = []
    var allActiveCards: [Card] = []
    var hardStrategyValid: Bool = false
    var winner: String = ""
    var rt_advantages: Double = 0.5
    var flip_interval: Double = 2.0
    var mistake_rate: Int = 50 // A probability of 50% the model will press the bell even there are not five fruits


//    var goalCard: Card
//    var goalCurrentSum: Int

    
    var m1 = modelPlayer("model1")
    var m2 = modelPlayer("model2")
    var m3 = modelPlayer("model3")
    var realplayer = humanPlayer("player")
    
    // The game will starts with the real player
    var playerInTurn: String = "player"
    // Indicator of whether someone just pressed the bell
    var pressStatus: bellPressed = bellPressed.nonPress

    // If the game is over
    var gameOver: Bool = false
    
    var rewardCardsPool: Array<Card> = []
    

    
    init() {
        decks = PlayableDecks( // genrating the playable decks
            deckOfCards: CardDeck( // generating the general deck
                maxNoCards: cardsNo,
                createCard: createCard),// creating each card
            numberOfPlayers: playersNo,
            getCards: splitDeck // spliting general deck into playable decks
        )
    }
    
    mutating func dealCards() {
        decks = PlayableDecks( // genrating the playable decks
            deckOfCards: CardDeck( // generating the general deck
                maxNoCards: cardsNo,
                createCard: createCard),// creating each card
            numberOfPlayers: playersNo,
            getCards: splitDeck // spliting general deck into playable decks
        )
    }
    
    // Run the model
    mutating func run() {

    }
    
    // Reset the model
    mutating func reset() {
        m1.reset()
        m2.reset()
        m3.reset()
        dealCards()
        run()
    }
    
    // Get all the face-up cards except the card wihch is going to be flipped/covered
    mutating func getActiveCards(except playerInTurn: String){
        // Refresh activeCards list
        priorActiveCards.removeAll()
        // If this player is not playerInTrun, not 0 point, and has flipped card, add that card to the activeCards list
        if playerInTurn != "player" && !decks.playerCards.isEmpty && decks.playerHasFlippedCard{
            priorActiveCards.append(decks.playerCards[0])
        }
        if playerInTurn != "model1" && !decks.modelCards1.isEmpty && decks.modelHasFlippedCard1{
            priorActiveCards.append(decks.modelCards1[0])
        }
        if playerInTurn != "model2" && !decks.modelCards2.isEmpty && decks.modelHasFlippedCard2{
            priorActiveCards.append(decks.modelCards2[0])
        }
        if playerInTurn != "model3" && !decks.modelCards3.isEmpty && decks.modelHasFlippedCard3{
            priorActiveCards.append(decks.modelCards3[0])
        }
    }
    
    // Get all the face-up cards
    mutating func getActiveCards(){
        // Refresh activeCards list
        allActiveCards.removeAll()
        // If this player is not playerInTrun, not 0 point, and has flipped card, add that card to the activeCards list
        if !decks.playerCards.isEmpty && decks.playerHasFlippedCard{
            allActiveCards.append(decks.playerCards[0])
        }
        if !decks.modelCards1.isEmpty && decks.modelHasFlippedCard1{
            allActiveCards.append(decks.modelCards1[0])
        }
        if !decks.modelCards2.isEmpty && decks.modelHasFlippedCard2{
            allActiveCards.append(decks.modelCards2[0])
        }
        if !decks.modelCards3.isEmpty && decks.modelHasFlippedCard3{
            allActiveCards.append(decks.modelCards3[0])
        }
    }
    
    /// Calculate the anticipation for the next flipped card
    /// Anticipation strategy for the easy mode
    /// 1. In priorActiveCards: Fruit class whose number is close to but smaller than 5, the player is expecting the next card is the same fruit and will add the sum of this kind of fruit to 5
    mutating func anticipationAnalysisEasy(){
        getActiveCards()
        var sumPerClass:Dictionary = ["a" : 0, "b" : 0, "c" : 0, "d" : 0]//Declaring dict for computing sums
        
        // Computing the sums for all the Classes/Figures present in the priorActiveCards
        for card in priorActiveCards{
            sumPerClass[card.figureClass]! += card.figuresNo
        }
        // Sorted by the values in descending order
        let _ = sumPerClass.sorted(by: { $0.value > $1.value })
        // Filter the fruit number which is smaller than 5
        sumPerClass = sumPerClass.filter({ $0.value < 5 })
        // Get the card whose fruit number is close to 5
        for card in priorActiveCards{
            if card.figureClass == sumPerClass.first?.key{
                // Update the goal
                updateGoalEasy(fromCard: card, withNum: sumPerClass.first!.value)
            }
        }
    }
    
    /// Anticipation strategy for the hard mode
    /// 2. In allActiveCards: If the number of fruit for playerInTurn's card class is greater than 5, the user is expecting this card is going to be covered by another class, and the remaining of this fruit is exactly 5
    mutating func anticipationAnalysisHard(){
        getActiveCards(except: playerInTurn)
        var sumPerClass:Dictionary = ["a" : 0, "b" : 0, "c" : 0, "d" : 0]//Declaring dict for computing sums
        
        // Computing the sums for all the Classes/Figures present in the priorActiveCards
        for card in priorActiveCards{
            sumPerClass[card.figureClass]! += card.figuresNo
        }

        // Filter the fruit number which is equal to 5
        sumPerClass = sumPerClass.filter({ $0.value == 5 })
        // Get the card whose fruit number is equal to 5
        for card in priorActiveCards{
            if card.figureClass == sumPerClass.first?.key{
                // And this card is the same with the card that's going to be covered
                if getTopCard(for: playerInTurn)?.figureClass == card.figureClass{
                    // Update the goal
                    updateGoalHard(fromCard: card, withNum: (5 + getTopCard(for: playerInTurn)!.figuresNo))
                    hardStrategyValid = true
                }
            }
        }
    }
   
    // Update the goal once someone just flipped a new card
    mutating func updateGoalEasy(fromCard goalCard: Card, withNum goalCurrentSum: Int){
        let goalName = goalCard.content
        
        // Clear the old goals
        m1.goalEasy.removeAll()
        m2.goalEasy.removeAll()
        m3.goalEasy.removeAll()
        
        // Update the goal
        m1.goalEasy[goalName] = goalCurrentSum
        m2.goalEasy[goalName] = goalCurrentSum
        m3.goalEasy[goalName] = goalCurrentSum
//        let m1chunk = Chunk(s: "goal", m: m1.model)
//        m1chunk.setSlot(slot: "fruitName", value: goalName)
//        m1chunk.setSlot(slot: "currentSum", value: String(goalCurrentSum))
//        m1.model.dm.addToDM(m1chunk)
//
//        let m2chunk = Chunk(s: "goal", m: m2.model)
//        m2chunk.setSlot(slot: "fruitName", value: goalName)
//        m2chunk.setSlot(slot: "currentSum", value: String(goalCurrentSum))
//        m2.model.dm.addToDM(m2chunk)
//
//        let m3chunk = Chunk(s: "goal", m: m3.model)
//        m3chunk.setSlot(slot: "fruitName", value: goalName)
//        m3chunk.setSlot(slot: "currentSum", value: String(goalCurrentSum))
//        m3.model.dm.addToDM(m3chunk)
    }
    
    // Update the goal once someone just flipped a new card
    mutating func updateGoalHard(fromCard goalCard: Card, withNum goalCurrentSum: Int){
        let goalName = goalCard.content
        
        // Clear the old goals
        m1.goalHard.removeAll()
        m2.goalHard.removeAll()
        m3.goalHard.removeAll()
        
        // Update the goal
        m1.goalHard[goalName] = goalCurrentSum
        m2.goalHard[goalName] = goalCurrentSum
        m3.goalHard[goalName] = goalCurrentSum
    }
    
    mutating func getTopCard(for player: String) -> (Card?){
        if (player == "player" && !decks.playerCards.isEmpty && decks.playerHasFlippedCard){
            return (decks.playerCards[0])
        }
        else if (player == "model1" && !decks.modelCards1.isEmpty && decks.modelHasFlippedCard1){
            return (decks.modelCards1[0])
        }
        else if (player == "model2" && !decks.modelCards2.isEmpty && decks.modelHasFlippedCard2){
            return (decks.modelCards2[0])
        }
        else if (player == "model3" && !decks.modelCards3.isEmpty && decks.modelHasFlippedCard3){
                return (decks.modelCards3[0])
        }
        return nil
    }
    
    // flip player's top card
    mutating func flipFirstCard(ofPlayer deckName: String){
        
        if (deckName == "player"){
            print("Flipped card from player's Deck")
            // If all the cards on this player's deck is face-down, flip the top card
            if !decks.playerHasFlippedCard{
                decks.playerHasFlippedCard.toggle()
            }
            // Remove the current top face-up card and append it to cardsToDeal(prize deck), then flip the next card automatically
            // If only 1 card left, do nothing
            else if decks.playerCards.count > 1{
                rewardCardsPool.append(decks.playerCards.removeFirst())
            }
        }
        else if (deckName == "model1"){
            print("Flipped card from model1's Deck")
            if !decks.modelHasFlippedCard1{
                decks.modelHasFlippedCard1.toggle()
            }
            else if decks.modelCards1.count > 1{
                rewardCardsPool.append(decks.modelCards1.removeFirst())
            }
        }
        else if (deckName == "model2"){
            print("Flipped card from model2's Deck")
            if !decks.modelHasFlippedCard2{
                decks.modelHasFlippedCard2.toggle()
            }
            else if decks.modelCards2.count > 1{
                rewardCardsPool.append(decks.modelCards2.removeFirst())
            }
        }
        else if (deckName == "model3"){
            print("Flipped card from model3's Deck")
            if !decks.modelHasFlippedCard3{
                decks.modelHasFlippedCard3.toggle()
            }
            else if decks.modelCards3.count > 1{
                rewardCardsPool.append(decks.modelCards3.removeFirst())
            }
        }
        
        // TODO: Move this out of the func to make the model logic more clear
        // updateGoal()
        // let _ = isGameOver()
    }
    
    //
    mutating func pressDecision(for player: String, isHardLevel: Bool) -> Bool {
        guard let topCard = getTopCard(for: playerInTurn) else {
            return false
        }
        
        if isHardLevel {
            var goalHard: [String: Int] = [:]

            switch player {
            case "model1":
                goalHard = m1.goalHard
            case "model2":
                goalHard = m2.goalHard
            case "model3":
                goalHard = m3.goalHard
            default:
                break
            }

            if goalHard.keys.first != topCard.content {
                return true
            }
        }

        var goalEasy: [String: Int] = [:]

        switch player {
        case "model1":
            goalEasy = m1.goalEasy
        case "model2":
            goalEasy = m2.goalEasy
        case "model3":
            goalEasy = m3.goalEasy
        default:
            break
        }

        if goalEasy.keys.first == topCard.content && (5 - goalEasy.values.first!) == topCard.figuresNo {
            return true
        }
        if goalEasy.keys.first == topCard.content {
            // Add a mistake_rate probability of returning true when the flipped card has the same kind of fruit with the expectation but there are not five fruits for this kind of fruit
            if Int.random(in: 0..<100) < mistake_rate {
                return true
            }
        }

        return false
    }


    
    mutating func pressBell(by player: String) -> Bool {
        var correctPress:Bool = false// Declaring flag for correct press
        var sumPerClass:Dictionary = ["a" : 0, "b" : 0, "c" : 0, "d" : 0]//Declaring dict for computing sums
        
        // Check if it is a correct press
        // Computing the sums for all the Classes/Figures present in on the table
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
                rewardCardsPool.append(decks.playerCards.removeFirst())
            }
            if !decks.modelCards1.isEmpty{
                rewardCardsPool.append(decks.modelCards1.removeFirst())
            }
            if !decks.modelCards2.isEmpty{
                rewardCardsPool.append(decks.modelCards2.removeFirst())
            }
            if !decks.modelCards3.isEmpty{
                rewardCardsPool.append(decks.modelCards3.removeFirst())
            }
            gameOver = isGameOver()
        }
        else{
            print("Wrong Press")
        }
        
        // Checking which player/model pressed the bell
        if (player == "player"){
            // If the player/model is wrong it losses between 1 and 3 cards from the back and deals them to the others
            if !correctPress{
                print("Player lost cards,dealt to active players")
                
                // Cards are dealt if there are still cards in the deck, otherwise a check for game over is performed
                if !decks.playerCards.isEmpty && !decks.modelCards1.isEmpty{
                    decks.modelCards1.append(decks.playerCards.removeLast())
                }
                if !decks.playerCards.isEmpty && !decks.modelCards2.isEmpty{
                    decks.modelCards2.append(decks.playerCards.removeLast())
                }
                if !decks.playerCards.isEmpty && !decks.modelCards3.isEmpty{
                    decks.modelCards3.append(decks.playerCards.removeLast())
                }
            }
            // Otherwise the player is correct and it gains all cards from the reward pool
            // and resetting the cards to be dealt array back to nil
            else{
                decks.playerCards.append(contentsOf: rewardCardsPool)
                rewardCardsPool.removeAll()
                playerInTurn = "player"
            }
        }
        else if (player == "model1"){
            // If the player/model is wrong it losses 3 cards from the back and deals them to the others
            if !correctPress{
                print("Model1 lost cards,dealt to active players")
                // Cards are dealt if there are still cards in the deck otherwise, a check for game over is performed
                if !decks.modelCards1.isEmpty && !decks.playerCards.isEmpty{
                    decks.playerCards.append(decks.modelCards1.removeLast())
                }
                if !decks.modelCards1.isEmpty && !decks.modelCards2.isEmpty{
                    decks.modelCards2.append(decks.modelCards1.removeLast())
                }
                if !decks.modelCards1.isEmpty && !decks.modelCards3.isEmpty{
                    decks.modelCards3.append(decks.modelCards1.removeLast())
                }
            }
            // Otherwise the player is correct and it gains all cards from the array with cards that need to dealt
            // and resetting the cards to be dealt array back to nil
            else{
                decks.modelCards1.append(contentsOf: rewardCardsPool)
                rewardCardsPool.removeAll()
                playerInTurn = "model1"
            }
        }
        else if (player == "model2"){
            // If the player/model is wrong it losses 3 cards from the back and deals them to the others
            if !correctPress{
                print("Model2 lost cards,dealt to active players")
                // Cards are dealt if there are still cards in the deck, otherwise a check for game over is performed
                if !decks.modelCards2.isEmpty && !decks.playerCards.isEmpty{
                    decks.playerCards.append(decks.modelCards2.removeLast())
                }
                if !decks.modelCards2.isEmpty && !decks.modelCards1.isEmpty{
                    decks.modelCards1.append(decks.modelCards2.removeLast())
                }
                if !decks.modelCards2.isEmpty && !decks.modelCards3.isEmpty{
                    decks.modelCards3.append(decks.modelCards2.removeLast())
                }
            }
            // Otherwise the player is correct and it gains all cards from the array with cards that need to dealt
            // and resetting the cards to be dealt array back to nil
            else{
                decks.modelCards2.append(contentsOf: rewardCardsPool)
                rewardCardsPool.removeAll()
                playerInTurn = "model2"
            }
        }
        else if (player == "model3"){
            // If the player/model is wrong it losses 3 cards from the back and deals them to the others
            if !correctPress{
                print("Model3 lost cards,dealt to active players")
                // Cards are dealt if there are still cards in the deck, otherwise a check for game over is performed
                if !decks.modelCards3.isEmpty && !decks.playerCards.isEmpty{
                    decks.playerCards.append(decks.modelCards3.removeLast())
                }
                if !decks.modelCards3.isEmpty && !decks.modelCards2.isEmpty{
                    decks.modelCards2.append(decks.modelCards3.removeLast())
                }
                if !decks.modelCards3.isEmpty && !decks.modelCards1.isEmpty{
                    decks.modelCards1.append(decks.modelCards3.removeLast())
                }
            }
            // Otherwise the player is correct and it gains all cards from the array with cards that need to dealt
            // and resetting the cards to be dealt array back to nil
            else{
                decks.modelCards3.append(contentsOf: rewardCardsPool)
                rewardCardsPool.removeAll()
                playerInTurn = "model3"
            }
        }
        // Update the score
        realplayer.score = decks.playerCards.count
        m1.score = decks.modelCards1.count
        m2.score = decks.modelCards2.count
        m3.score = decks.modelCards3.count
        return correctPress
    }
    
    // Check if the game is over
    // TODO: make gameOver published and terminate the game if it's true
    mutating func isGameOver() -> Bool {
        if decks.playerCards.isEmpty{
            gameOver = true
            print("Player has lost")
        }
        else if decks.modelCards1.isEmpty && decks.modelCards2.isEmpty && decks.modelCards3.isEmpty{
            gameOver = true
            print("Player won")
        }
        return gameOver
    }
    
    // TODO: finish this
    // End the game
    mutating func endGame(isGameOver: Bool) {
        if isGameOver{
            if decks.playerCards.isEmpty {
                winner = "Model"
            } else {
                winner = "Player"
            }
        }
    }

}
