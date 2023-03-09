//
//  HalliGalliViewModel.swift
//  test
//
//  Created by P. Pintea on 2/15/23.
//

import Foundation

// function that creates a card
func createCard(cardIndex: Int) -> Card{
    let cardsPerClass: Int = HGViewModel.cardReplicas.reduce(0,+)
    var cardFigure: String
    var cardName: String
    var cardNumber: Int
    var cardId: String
    
    // dictating the correct class and figure (image on card) that the cards should have
    if cardIndex < cardsPerClass{
        cardFigure = HGViewModel.cardFigures[0]
        cardName = HGViewModel.cardNames[0]
    }
    else{
        cardFigure = HGViewModel.cardFigures[Int(cardIndex/cardsPerClass)]
        cardName = HGViewModel.cardNames[Int(cardIndex/cardsPerClass)]
    }
    
    // dictating the correct number of figures that should be on the card
    if (cardIndex % cardsPerClass) < HGViewModel.cardReplicas[0]{
        cardNumber = 1
    }
    else if (cardIndex % cardsPerClass) < HGViewModel.cardReplicas[...1].reduce(0,+){
        cardNumber = 2
    }
    else if (cardIndex % cardsPerClass) < HGViewModel.cardReplicas[...2].reduce(0,+){
        cardNumber = 3
    }
    else if (cardIndex % cardsPerClass) < HGViewModel.cardReplicas[...3].reduce(0,+){
        cardNumber = 4
    }
    else{
        cardNumber = 5
    }
    
    cardId = "\(cardName)_\(cardNumber)"
    
    // returning a card with the correct info
    return Card(id: cardId,figuresNo: cardNumber, figureClass: cardName, content: cardFigure)
}

// function that splits deck of cards into player and model decks
func splitDeck(deck: CardDeck, numberOfPlayers: Int) -> (Array<Card>, Array<Card>, Array<Card>, Array<Card>){
    var playerDeck: Array<Card>
    var modelDeck1: Array<Card>
    var modelDeck2: Array<Card>
    var modelDeck3: Array<Card>
    
    // shuffling the deck of cards
    var shuffledCards: Array<Card> = deck.cards
    shuffledCards.shuffle()
    
    // dividing total number of cards to no. players and adding that many cards to the player deck
    playerDeck = Array(shuffledCards[..<Int(shuffledCards.count/numberOfPlayers)])
    
    // storing the rest of the cards into the modelDeck
    //TODO: change deck cuz rn it is not done correctly, it is still done as if there were only two decks one for player and one for model
    modelDeck1 = Array(shuffledCards[Int(shuffledCards.count / numberOfPlayers)..<(shuffledCards.count - (shuffledCards.count % numberOfPlayers))])
    modelDeck2 = Array(shuffledCards[Int(shuffledCards.count / numberOfPlayers)..<(shuffledCards.count - (shuffledCards.count % numberOfPlayers))])
    modelDeck3 = Array(shuffledCards[Int(shuffledCards.count / numberOfPlayers)..<(shuffledCards.count - (shuffledCards.count % numberOfPlayers))])
    
    
    return (playerDeck, modelDeck1, modelDeck2, modelDeck3)
}

class HGViewModel: ObservableObject{
    
    //static variables to be used to build the game
    static let playersNo: Int = 4 // dictates number of players
    static let cardsNo: Int = 56 // dictates number of cards
    // dictates how many replicas of a card there should be, the index of the array
    // dictates how many figures should the replica have
    static let cardReplicas: [Int] = [5, 3, 3, 2, 1]
    static let cardFigures: [String] = ["apple", "avocado", "orange", "blueberry"] // dictates figures that will be on the cards
    static let cardNames: [String] = ["a", "b", "c", "d"] // dictates the class of the card, each element relates to one figure
    
    // Declaring the model itself
    @Published private var model = HGModel(
        playableDecks: PlayableDecks( // genrating the playable decks
            deckOfCards: CardDeck( // generating the general deck
                maxNoCards: cardsNo,
                createCard: createCard),// creating each card
            numberOfPlayers: playersNo,
            getCards: splitDeck // spliting general deck into playable decks
        )
    )
    
    
    
    // TODO: use objectWillChange.send() in functions to show the view that the model changes
    
    var decks: PlayableDecks{
        model.decks
    }
    
    
    var modelState: String{
        model.modelState.description
    }
}
