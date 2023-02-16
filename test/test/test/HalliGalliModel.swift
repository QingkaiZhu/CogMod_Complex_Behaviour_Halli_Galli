//
//  HalliGalliModel.swift
//  test
//
//  Created by P. Pintea on 2/15/23.
//

import Foundation

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

struct HGModel{
    let model = Model()
    var modelState: State = .none
    init(){
        model.loadModel(fileName: "rps")// TODO: Change model afterwards
        model.run()
    }
}
