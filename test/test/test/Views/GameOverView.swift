//
//  GameOverView.swift
//  test
//
//  Created by Kai on 2023/4/11.
//
import SwiftUI

struct GameOverView: View {
    
    @StateObject var game: HGViewModel

    var body: some View {
        ZStack {
            Image("launcher_pic")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack(spacing: 40) {
                Text("Game Over")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                VStack {
                    Text("Winner:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("\(game.winner)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Button(action: {
                    game.gameOver = false
                    game.showHGView = false
                    game.model = HGModel()
                    StartView(viewModel: game)
                }, label: {
                    Text("Restart")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .background(Color("blue3"))
                        .cornerRadius(10)
                })
                .padding(.horizontal)
            }
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(game: HGViewModel())
    }
}
