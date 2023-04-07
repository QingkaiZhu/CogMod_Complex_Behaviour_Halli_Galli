//
//  HalliGalliViewModel.swift
//  test
//
//  Created by P. Pintea on 2/15/23.
//

import Foundation

class HGViewModel: ObservableObject{
    
    //static variables to be used to build the game
    let playersNo: Int = 4 // dictates number of players
    let cardsNo: Int = 56 // dictates number of cards
    // dictates how many replicas of a card there should be, the index of the array
    // dictates how many figures should the replica have
    static let cardReplicas: [Int] = [5, 3, 3, 2, 1]
    static let cardFigures: [String] = ["apple", "avocado", "blueberry", "oriange"] // dictates figures that will be on the cards
    static let cardClasses: [String] = ["a", "b", "c", "d"] // dictates the class of the card, each element relates to one figure
    
    @Published var showHGView: Bool = false
    
    // Declaring the model itself
    @Published private var model: HGModel
    
    // TODO: use objectWillChange.send() in functions to show the view that the model changes
    
    init() {
        model = HGModel(
            playableDecks: PlayableDecks( // genrating the playable decks
                deckOfCards: CardDeck( // generating the general deck
                    maxNoCards: cardsNo,
                    createCard: createCard),// creating each card
                numberOfPlayers: playersNo,
                getCards: splitDeck // spliting general deck into playable decks
            )
        )
    }
    
    func getCardInfo(for player: String) -> (Card?, Bool){
        if ((player == "player") && !model.decks.playerCards.isEmpty){
            print("Getting card from player deck")
            return (model.decks.playerCards[0], model.decks.playerHasFlippedCard)
        }
        else if ((player == "model1") && !model.decks.modelCards1.isEmpty){
            print("Getting card from model1's Deck")
            return (model.decks.modelCards1[0], model.decks.modelHasFlippedCard1)
        }
        else if ((player == "model2") && !model.decks.modelCards2.isEmpty){
            print("Getting card from model2's Deck")
            return (model.decks.modelCards2[0], model.decks.modelHasFlippedCard2)
        }
        else if ((player == "model3") && !model.decks.modelCards3.isEmpty){
            print("Getting card from model3's Deck")
            return (model.decks.modelCards3[0], model.decks.modelHasFlippedCard3)
        }
        else {
            return (nil, false)
        }
    }
    
    func flip(cardOf player: String){
        model.flipFirstCard(ofPlayer: player)
        objectWillChange.send()
    }
    
    func pressBell(_ player: String){
        print("Bell press \(player)")
        model.pressBell(by: player)
        objectWillChange.send()
    }
    
    
    // If reset is called the model is intialized again from the start
    func reset(){
        model = HGModel(
            playableDecks: PlayableDecks( // genrating the playable decks
                deckOfCards: CardDeck( // generating the general deck
                    maxNoCards: cardsNo,
                    createCard: createCard),// creating each card
                numberOfPlayers: playersNo,
                getCards: splitDeck // spliting general deck into playable decks
            )
        )
        objectWillChange.send()
    }
    
    func getScore(for player:String) -> Int{
        if (player == "player"){
            return model.decks.playerCards.count
        }
        else if (player == "model1"){
            return model.decks.modelCards1.count
        }
        else if (player == "model2"){
            return model.decks.modelCards2.count
        }
        else{
            return model.decks.modelCards3.count
        }
    }
    
    
//    var modelState: String{
//        model.modelState.description
//    }
}
