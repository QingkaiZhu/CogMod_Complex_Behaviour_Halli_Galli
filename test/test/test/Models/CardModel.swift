//
//  CardModel.swift
//  test
//
//  Created by P. Pintea on 2/15/23.
//

import Foundation

// struct that dictates a card format
struct Card: Identifiable{
    // Id reference of the image: content_figureNo e.g. apple_1
    var id: String
    // The number of the fruit on each card
    var figuresNo: Int
    // a, b, c, d which represents the fruit class
    var figureClass: String
    // The fruit name of the class
    var content: String
}

// struct that dictates the general deck which contains all the 56 cards
struct CardDeck{
    private(set) var cards: Array<Card> // array for the 56 cards
    
    init(maxNoCards: Int, createCard: (Int) -> Card){
        cards = []
        
        // generating the deck(56 cards) one card at a time
        for numberIndex in 0 ..< maxNoCards{
            let card = createCard(numberIndex) // generating card
            cards.append(card) // appending the card
        }
        print("\(maxNoCards) cards were initialized")
    }
}

// function that creates a card
func createCard(cardIndex: Int) -> Card{
    let cardsPerClass: Int = HGModel.cardReplicas.reduce(0,+)
    var cardFigure: String // content/fruit name: apple
    var cardClass: String // figureClass: a, b, b, c
    var cardNumber: Int // figureNo: 1 to 5
    var cardId: String // Id: cardFigure_cardNumber e.g. apple_1 the reference of the asset
    
    // dictating the correct class and figure (image on card) that the cards should have
    cardFigure = HGModel.cardFigures[cardIndex/cardsPerClass]
    cardClass = HGModel.cardClasses[cardIndex/cardsPerClass]
//    if cardIndex < cardsPerClass{
//        cardFigure = HGViewModel.cardFigures[0]
//        cardClass = HGViewModel.cardClasses[0]
//    }
//    else{
//        cardFigure = HGViewModel.cardFigures[Int(cardIndex/cardsPerClass)]
//        cardClass = HGViewModel.cardClasses[Int(cardIndex/cardsPerClass)]
//    }
    
    // dictating the correct number of figures that should be on the card
    if (cardIndex % cardsPerClass) < HGModel.cardReplicas[0]{
        cardNumber = 1
    }
    else if (cardIndex % cardsPerClass) < HGModel.cardReplicas[...1].reduce(0,+){
        cardNumber = 2
    }
    else if (cardIndex % cardsPerClass) < HGModel.cardReplicas[...2].reduce(0,+){
        cardNumber = 3
    }
    else if (cardIndex % cardsPerClass) < HGModel.cardReplicas[...3].reduce(0,+){
        cardNumber = 4
    }
    else{
        cardNumber = 5
    }
    
    cardId = "\(cardFigure)_\(cardNumber)"
    
    // returning a card with the correct info
    return Card(id: cardId,figuresNo: cardNumber, figureClass: cardClass, content: cardFigure)
}

// function that splits deck of cards into player and model decks
func splitDeck(deck: CardDeck, numberOfPlayers: Int) -> (Array<Card>, Array<Card>, Array<Card>, Array<Card>){
    var playerDeck: Array<Card>
    var modelDeck1: Array<Card>
    var modelDeck2: Array<Card>
    var modelDeck3: Array<Card>
    
    // shuffling the deck of cards
    // TODO: Maybe we can change deck.cards non private and shuffle it directlly?
    // TODO: Animation for dealing the cards
    var shuffledCards: Array<Card> = deck.cards
    shuffledCards.shuffle()
    
    // dividing total number of cards to no. players and adding that many cards to the player deck
    playerDeck = Array(shuffledCards[..<Int(shuffledCards.count/numberOfPlayers)])
    
    // storing the rest of the cards into the modelDeck
    modelDeck1 = Array(shuffledCards[Int(shuffledCards.count / numberOfPlayers)..<(2 * Int(shuffledCards.count / numberOfPlayers))])
    modelDeck2 = Array(shuffledCards[(2 * Int(shuffledCards.count / numberOfPlayers))..<(3 * Int(shuffledCards.count / numberOfPlayers))])
    modelDeck3 = Array(shuffledCards[(3 * Int(shuffledCards.count / numberOfPlayers))..<(shuffledCards.count - (shuffledCards.count % numberOfPlayers))])
    
    print("cards splited")
    return (playerDeck, modelDeck1, modelDeck2, modelDeck3)
}


// struct that dictates the playable decks which contains array of cards for the 4
// players respectively
struct PlayableDecks{
    
    var playerCards: Array<Card>
    var modelCards1: Array<Card>
    var modelCards2: Array<Card>
    var modelCards3: Array<Card>
    
    var playerHasFlippedCard: Bool = false
    var modelHasFlippedCard1: Bool = false
    var modelHasFlippedCard2: Bool = false
    var modelHasFlippedCard3: Bool = false
    
    // Deal cards(CardDeck) for all the players
    // The number of the return array is fixed, so it's pointless to use variable numberOfPlayers
    // TODO: fixme to return the arraies according to numberOfPlayers
    init(deckOfCards: CardDeck, numberOfPlayers: Int, getCards: (CardDeck, Int) -> (Array<Card>, Array<Card>, Array<Card>, Array<Card>)){
        (playerCards, modelCards1, modelCards2, modelCards3) = getCards(deckOfCards, numberOfPlayers)
    }
    
    // Function to reward the winner of a success bell pressing
    // Give all the flipped/fact-up cards to the winner
    // TODO: We should use a card array to track all the flipped cards
//    mutating func cardReward() {
//
//    }
    
    // Function to punish the player/model who rings the bell by mistake
    // Give each other player one card from his face-down pack as a penalty
//    mutating func cardPenalty() {
//
//    }
}

