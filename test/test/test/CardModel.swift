//
//  CardModel.swift
//  test
//
//  Created by P. Pintea on 2/15/23.
//

import Foundation

struct CardDeck<CardContent>{
    
    private(set) var cards: Array<Card>
    
    init(maxNoCards: Int, createCard: (Int) -> Card){
        cards = Array<Card>()
        
        for numberIndex in 0 ..< maxNoCards{
            let card = createCard(numberIndex)
            cards.append(card)
        }
        
    }
    
    struct Card{
        var figuresNo: Int
        var figureClass: String
        var content: CardContent
        
    }
        
}
