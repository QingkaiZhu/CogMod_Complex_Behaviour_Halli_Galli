//
//  GameOverView.swift
//  test
//
//  Created by Kai on 2023/4/11.
//

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var game: HGViewModel

    var body: some View {
        VStack {
            Text("Game Over")
            Text("Winner: \(game.winner)")
            Button(action: {
                game.gameOver = false
                game.model = HGModel()
            }, label: {
                Text("Restart")
            })
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
    }
}
