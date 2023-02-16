//
//  HalliGalliViewModel.swift
//  test
//
//  Created by P. Pintea on 2/15/23.
//

import Foundation

func createCard(cardIndex: Int) -> CardDeck<String>.Card{
    let cardsPerClass: Int = HGViewModel.cardReplicas.reduce(0,+)
    var cardFigure: String
    var cardName: String
    var cardNumber: Int
    if cardIndex < cardsPerClass{
        cardFigure = HGViewModel.cardFigures[0]
        cardName = HGViewModel.cardNames[0]
    }
    else{
        //TODO: ask teacher if int() in swift drops everything after decimal point
        cardFigure = HGViewModel.cardFigures[Int(cardIndex/cardsPerClass)]
        cardName = HGViewModel.cardNames[Int(cardIndex/cardsPerClass)]
    }
    
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
    
    return CardDeck.Card(figuresNo: cardNumber, figureClass: cardName, content: cardFigure)
}

class HGViewModel: ObservableObject{
    static let cardsNo: Int = 56
    static let cardReplicas: [Int] = [5, 3, 3, 2, 1]
    static let cardFigures: [String] = ["🍑", "🍉", "🍌", "🍍"]
    static let cardNames: [String] = ["a", "b", "c", "d"]
    
    private var deckOfCards: CardDeck<String> = CardDeck(maxNoCards: cardsNo, createCard: createCard)
    
    @Published private var model = HGModel()
    
    
    var modelState: String{
        model.modelState.description
    }
}
