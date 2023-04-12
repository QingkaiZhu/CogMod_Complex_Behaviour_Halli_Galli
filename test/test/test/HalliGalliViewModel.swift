//
//  HalliGalliViewModel.swift
//  test
//
//  Created by P. Pintea on 2/15/23.
//

import Foundation

class HGViewModel: ObservableObject{
    
    @Published var showHGView: Bool = false
    
    // Declaring the model itself
    @Published var model: HGModel
    
    @Published var isPlayerCardTappable: Bool = true
    @Published var gameOver: Bool = false
    @Published var winner: String = ""
    @Published var isHardLevel: Bool = false
    
    private var startTime = Date()
    private var timer: Timer?

    // TODO: use objectWillChange.send() in functions to show the view that the model changes
    
    init() {
        model = HGModel()
//        model.run()
//        model.update()
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
    
    // Check if the deck is empty for the given player
    func isDeckEmpty(forPlayer player: String) -> Bool {
        switch player {
        case "player":
            return model.decks.playerCards.isEmpty
        case "model1":
            return model.decks.modelCards1.isEmpty
        case "model2":
            return model.decks.modelCards2.isEmpty
        case "model3":
            return model.decks.modelCards3.isEmpty
        default:
            return true
        }
    }
    
    func flip(cardOf player: String){
        switch player {
        case "model1":
//            let modelStartTime = model.m1.model.time
//            // TODO: customized actr forget rate, it seems we don't record the time for flipping
//            model.m1.model.run()
//            let modelRunTime = model.m1.model.time - modelStartTime
//            model.m2.model.run(maxTime: modelRunTime)
//            model.m3.model.run(maxTime: modelRunTime)
//            timer = Timer.scheduledTimer(withTimeInterval: modelRunTime, repeats: false, block: {_ in self.model.flipFirstCard(ofPlayer: "model1")})
            model.flipFirstCard(ofPlayer: "model1")
        case "model2":
//            let modelStartTime = model.m2.model.time
//            model.m2.model.run()
//            let modelRunTime = model.m2.model.time - modelStartTime
//            model.m1.model.run(maxTime: modelRunTime)
//            model.m3.model.run(maxTime: modelRunTime)
//            timer = Timer.scheduledTimer(withTimeInterval: modelRunTime, repeats: false, block: {_ in self.model.flipFirstCard(ofPlayer: "model2")})
            model.flipFirstCard(ofPlayer: "model2")
        case "model3":
//            let modelStartTime = model.m3.model.time
//            model.m3.model.run()
//            // TODO: do something
//            let modelRunTime = model.m3.model.time - modelStartTime
//            model.m1.model.run(maxTime: modelRunTime)
//            model.m2.model.run(maxTime: modelRunTime)
//            timer = Timer.scheduledTimer(withTimeInterval: modelRunTime, repeats: false, block: {_ in self.model.flipFirstCard(ofPlayer: "model3")})
            model.flipFirstCard(ofPlayer: "model3")
        default:
//            startTime = Date()
//            timer = Timer.scheduledTimer(withTimeInterval: 1.0 + Double.random(in: 0..<1), repeats: false, block: { _ in self.model.flipFirstCard(ofPlayer: "player")})
//            let elapsedTime = Double(Date().timeIntervalSince(startTime))
//            model.m1.model.run(maxTime: elapsedTime)
//            model.m2.model.run(maxTime: elapsedTime)
//            model.m3.model.run(maxTime: elapsedTime)
            model.flipFirstCard(ofPlayer: "player")
        }
        objectWillChange.send()
    }
    
    func flipCardsAutomatically() {
        isPlayerCardTappable = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 + Double.random(in: 0..<1)) {
            self.flip(cardOf: "model1")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 + Double.random(in: 0..<1)) {
                self.flip(cardOf: "model2")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 + Double.random(in: 0..<1)) {
                    self.flip(cardOf: "model3")
                    self.isPlayerCardTappable = true
                }
            }
        }
    }
    
    func pressBell(_ player: String) -> Bool{
        print("Bell press \(player)")
        let isCorrect = model.pressBell(by: player)
        objectWillChange.send()
        return isCorrect
    }
    
    // If reset is called the model is intialized again from the start
    func reset(){
        model.dealCards()
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
}
