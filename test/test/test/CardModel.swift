//
//  CardModel.swift
//  test
//
//  Created by P. Pintea on 2/15/23.
//

import Foundation
// struct that dictates a card format
struct Card{
    var figuresNo: Int
    var figureClass: String
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
    var modelCards: Array<Card>
    
    init(deckOfCards: CardDeck, numberOfPlayers: Int, getCards: (CardDeck, Int) -> (Array<Card>, Array<Card>)){
        (playerCards, modelCards) = getCards(deckOfCards, numberOfPlayers)
    }
        
}
