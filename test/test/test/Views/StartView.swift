//
//  StartView.swift
//  test
//
//  Created by Kai on 2023/4/5.
//

import SwiftUI

struct StartView: View {
    @StateObject var viewModel = HGViewModel()
    @Binding var isHardLevel: Bool
    
    var body: some View {
        ZStack {
            Color("blue0").ignoresSafeArea()
            
            if viewModel.showHGView {
                ContentView(game: viewModel)
            } else {
                VStack {
                    Spacer()
                    Text("Halli Galli")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                    Spacer()
                    // Add a toggle for the user to change the isHardLevel setting
                    Toggle(isOn: $isHardLevel) {
                        Text("Hard Level")
                            .font(.headline)
                    }
                    Button(action: {
                        viewModel.showHGView = true
                    }) {
                        Text("Start Game")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding()
                    Spacer()
                }
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    @State private static var isHardLevel = false
    
    static var previews: some View {
        StartView(isHardLevel: $isHardLevel)
    }
}


