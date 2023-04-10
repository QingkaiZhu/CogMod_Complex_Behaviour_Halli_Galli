//
//  HalliGalliModel.swift
//  test
//
//  Created by P. Pintea on 2/15/23.
//

import Foundation

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
    
    var m1 = modelPlayer("model1")
    var m2 = modelPlayer("model2")
    var m3 = modelPlayer("model3")
    
    // The game will starts with the real player
    var playerInTurn: String = "player"
    // Indicator of whether someone just pressed the bell
    var pressStatus: bellPressed = bellPressed.nonPress

    // If the game is over
    var gameOver: Bool = false
    
    var rewardCardsPool: Array<Card> = []
    
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
//        if isNewRround(){
//            m1.runFromBegining(turnOf: playerInTurn)
//            m2.runFromBegining(turnOf: playerInTurn)
//            m3.runFromBegining(turnOf: playerInTurn)
//        } else {
//            m1.runFromInteruption(turnOf: playerInTurn)
//            m2.runFromInteruption(turnOf: playerInTurn)
//            m3.runFromInteruption(turnOf: playerInTurn)
//        }
        // TODO: fixme
        // turnSchedule(from: playerInTurn)
    }
    
    // Reset the model
    mutating func reset() {
        m1.reset()
        m2.reset()
        m3.reset()
        dealCards()
        run()
    }
    
//    mutating func turnSchedule(from player: String) {
//        let scheduleList: Array<String> = ["player", "model1", "model2", "model3"]
//        guard let i = scheduleList.firstIndex(of: player) else { return }
//
//        var currentIndex = i
//
//        while pressStatus != bellPressed.rightPress && !gameOver {
//            let currentPlayer = scheduleList[currentIndex]
//
//            if !isDeckEmpty(forPlayer: currentPlayer) {
//                flipFirstCard(ofPlayer: currentPlayer)
//            }
//
//            // Move on to the next player
//            currentIndex = (currentIndex + 1) % scheduleList.count
//        }
//    }
//
//    // Check if the deck is empty for the given player
//    func isDeckEmpty(forPlayer player: String) -> Bool {
//        switch player {
//        case "player":
//            return decks.playerCards.isEmpty
//        case "model1":
//            return decks.modelCards1.isEmpty
//        case "model2":
//            return decks.modelCards2.isEmpty
//        case "model3":
//            return decks.modelCards3.isEmpty
//        default:
//            return true
//        }
//    }
    
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
    /// 1. In priorActiveCards: Fruit class whose number is close to but smaller than 5, the player is expecting the next card is the same fruit and will add the sum of this fruit to 5
    /// 2. In allActiveCards: If the number of fruit for playerInTurn's card class is greater than 5, the user is expecting this card is going to be covered by another class, and the remaining of this fruit is exactly 5
    mutating func anticipationAnalysis(){
        
    }
   
    // Update the goal once someone just flipped a new card
    mutating func updateGoal(){
        let (goalCard, _) = getCardInfo(for: playerInTurn)
        let goalName = goalCard?.content
        let goalCurrentSum = goalCard?.figuresNo
        
        let m1chunk = Chunk(s: "goal", m: m1.model)
        m1chunk.setSlot(slot: "fruitName", value: goalName!)
        m1chunk.setSlot(slot: "currentSum", value: String(goalCurrentSum!))
        m1.model.dm.addToDM(m1chunk)
        
        let m2chunk = Chunk(s: "goal", m: m2.model)
        m2chunk.setSlot(slot: "fruitName", value: goalName!)
        m2chunk.setSlot(slot: "currentSum", value: String(goalCurrentSum!))
        m2.model.dm.addToDM(m2chunk)
        
        let m3chunk = Chunk(s: "goal", m: m3.model)
        m3chunk.setSlot(slot: "fruitName", value: goalName!)
        m3chunk.setSlot(slot: "currentSum", value: String(goalCurrentSum!))
        m3.model.dm.addToDM(m3chunk)
    }
    
    mutating func getCardInfo(for player: String) -> (Card?, Bool){
        if ((player == "player") && !decks.playerCards.isEmpty){
            return (decks.playerCards[0], decks.playerHasFlippedCard)
        }
        else if ((player == "model1") && !decks.modelCards1.isEmpty){
            return (decks.modelCards1[0], decks.modelHasFlippedCard1)
        }
        else if ((player == "model2") && !decks.modelCards2.isEmpty){
            return (decks.modelCards2[0], decks.modelHasFlippedCard2)
        }
        else if ((player == "model3") && !decks.modelCards3.isEmpty){
                return (decks.modelCards3[0], decks.modelHasFlippedCard3)
        }
        else {
            return (nil, false)
        }
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
    
    mutating func pressDecision (){
        
    }
    
    // TODO: Update bellPressed
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
            print("Player won")
            gameOver = true
        }
        return gameOver
    }
    
    // TODO: finish this
    // End the game
    mutating func endGame(isGameOver: Bool) {
        if isGameOver{
            
        }
    }
    
    // Check if it is the begining of a round(begining of the game or someone just won a round by a successfull pressing)
//    func isNewRround() -> Bool {
//        return !decks.modelHasFlippedCard1 && !decks.modelHasFlippedCard2 && !decks.modelHasFlippedCard3 && !decks.playerHasFlippedCard
//    }
}
