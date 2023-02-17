//
//  HalliGalliModel.swift
//  test
//
//  Created by P. Pintea on 2/15/23.
//

import Foundation

// model has 2 states press and nopress,
// creates a transition between the notation types that can be taken by the two states
enum State: CustomStringConvertible{
    case press
    case none
    var description: String{
        switch self{
        case .press: return "press"
        case .none: return "nopress"
        }
    }
    static func findAction(_ actionString: String) -> State{
        switch actionString{
        case "press": return(.press)
        default: return(.none)
        }
    }
}

// declaring the game model struct
struct HGModel{
    //declarinf the variables needed by the model
    let model = Model()
    var modelState: State = .none
    var decks: PlayableDecks
    
    init(playableDecks: PlayableDecks){
        decks = playableDecks // saving the playable decks into the model
        model.loadModel(fileName: "rps")// TODO: Change model afterwards
        model.run()
    }
}
