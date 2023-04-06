//
//  StartView.swift
//  test
//
//  Created by Kai on 2023/4/5.
//

import SwiftUI

struct StartView: View {
    @State private var showGameView = false
    
    var body: some View {
        ZStack {
            Color("blue0").ignoresSafeArea()
            
            if showGameView {
                ContentView(game: HGViewModel(), showGameView: $showGameView)
            } else {
                VStack {
                    Spacer()
                    Text("Halli Galli")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        showGameView = true
                    }) {
                        Text("Start Game")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}

