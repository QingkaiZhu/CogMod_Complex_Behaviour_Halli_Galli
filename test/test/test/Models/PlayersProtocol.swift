//
//  Players.swift
//  test
//
//  Created by Kai on 2023/3/14.
//

// Right now let's put the protocol aside 
import Foundation

// Protocol for the real player and model players
protocol PlayersProtocol {
    var id: String {get}
    // An array to store all the flipped cards for this player/model,
    // the first element of this array is the top face-up card
    var flipedCards: Array<Card> {get set}
    var score: Int {get set}
    var mood: Emotion {get set}
    var actState: actionState {get set}
    
    mutating func run()
    mutating func reset()
    mutating func update()
    func isGameOver()
    mutating func pressBell()

}
