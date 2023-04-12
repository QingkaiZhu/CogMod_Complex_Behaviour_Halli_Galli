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
                ZStack {
                    VStack{
                        FruitAnime()
                        FruitAnime()
                        FruitAnime()
                        FruitAnime()
                        FruitAnime()
                        FruitAnime()
                        FruitAnime()
                    }
                VStack {
                    Spacer()
                    Text("Halli Galli")
                        .font(.system(size: 48))
                        .fontWeight(.bold)
                        .foregroundColor(Color("blue3"))
                    Spacer()
                    // Add a toggle for the user to change the isHardLevel setting
                    Toggle(isOn: $isHardLevel) {
                        Text("Hard Level")
                            .fontWeight(.bold)
                            .font(.largeTitle)
                            .foregroundColor(Color("red1"))
                    }
                    .padding([.leading,.trailing], 75)
                    Button(action: {
                        viewModel.showHGView = true
                    }) {
                        Text("Start Game")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("blue3"))
                            .cornerRadius(10)
                    }
                    .padding()
                    Spacer()
                }}
            }
        }
    }
}
struct FruitAnime: View {
    @State var scale = 1.5
    var body:some View {
        HStack{
            Spacer()
            Image("orange_1")
                .scaleEffect(scale)
                .onAppear{
                    let baseAnimation = Animation.easeInOut(duration: 1)
                    let repeated = baseAnimation.repeatForever(autoreverses: true)
                    withAnimation(repeated){
                        scale=1
                    }
                }
            Spacer()
            Image("blueberry_1")
                .scaleEffect(scale)
                .onAppear{
                    let baseAnimation = Animation.easeInOut(duration: 1)
                    let repeated = baseAnimation.repeatForever(autoreverses: true)
                    withAnimation(repeated){
                        scale=1
                        
                    }
                }
            Spacer()
            Image("apple_1")
                .scaleEffect(scale)
                .onAppear{
                    let baseAnimation = Animation.easeInOut(duration: 1)
                    let repeated = baseAnimation.repeatForever(autoreverses: true)
                    withAnimation(repeated){
                        scale=1
                    }
                }
            Spacer()
            Image("avocado_1")
                .scaleEffect(scale)
                .onAppear{
                    let baseAnimation = Animation.easeInOut(duration: 1)
                    let repeated = baseAnimation.repeatForever(autoreverses: true)
                    withAnimation(repeated){
                        scale=1
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


