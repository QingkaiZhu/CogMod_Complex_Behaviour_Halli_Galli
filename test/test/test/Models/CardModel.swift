//
//  CardModel.swift
//  test
//
//  Created by P. Pintea on 2/15/23.
//

import Foundation
// struct that dictates a card format
struct Card: Identifiable{
    var id: String
    // The number of the fruit on each card
    var figuresNo: Int
    // a, b, c, d which represents the fruit class
    var figureClass: String
    // The fruit name of the class
    var content: String
    
}

// struct that dictates the general deck
struct CardDeck{
    
    private(set) var cards: Array<Card> // declaring the type of the cards variable
    
    init(maxNoCards: Int, createCard: (Int) -> Card){
        cards = Array<Card>()
        
        // generating the deck one card at a time
        for numberIndex in 0 ..< maxNoCards{
            let card = createCard(numberIndex) // generating card
            cards.append(card) // appending the card
        }
        
    }
        
}


// struct that dictates the playable decks
struct PlayableDecks{
    
    var playerCards: Array<Card>
    var modelCards1: Array<Card>
    var modelCards2: Array<Card>
    var modelCards3: Array<Card>
    
    var playerHasFlippedCard: Bool = false
    var modelHasFlippedCard1: Bool = false
    var modelHasFlippedCard2: Bool = false
    var modelHasFlippedCard3: Bool = false
    
    
    init(deckOfCards: CardDeck, numberOfPlayers: Int, getCards: (CardDeck, Int) -> (Array<Card>, Array<Card>, Array<Card>, Array<Card>)){
        (playerCards, modelCards1, modelCards2, modelCards3) = getCards(deckOfCards, numberOfPlayers)
    }
    
    // Function to reward the winner of a success bell pressing
    // Give all the flipped/fact-up cards to the winner
    // TODO: We should use a card array to track all the flipped cards
    mutating func cardReward() {
        
    }
    
    // Function to punish the player/model who rings the bell by mistake
    // Give each other player one card from his face-down pack as a penalty
    mutating func cardPenalty() {
        
    }
        
}

