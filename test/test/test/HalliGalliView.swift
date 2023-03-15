//
//  ContentView.swift
//  HalliGalli
//
//  Created by 王超仪 on 04/03/2023.
//

import SwiftUI

// TODO: needs changing needs to accept a card directly
struct CardView: View{
    let card: Card?
    let isFlipped: Bool
    let width:CGFloat = 120
    let height:CGFloat = 150
    //let fruitNumber:Int
    //let fruitName:String
    //let fruitImage:String
    //@Binding var degree: Double
    
    init(player: String, getInfo: (String) -> (Card?, Bool)){
        (card, isFlipped) = getInfo(player)
    }
    
    
    var body: some View{
        ZStack{
            switch card{
            case .some(let card):
                if isFlipped{
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.white)
                        .frame(width:width,height:height)
                        .shadow(color:.gray,radius:2,x:0,y:0)
                    Image(String(card.id))
                }
                else{
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color("blue3").opacity(0.7),lineWidth: 3)
                        .frame(width:width,height:height)
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color("blue2").opacity(0.2))
                        .frame(width:width,height:height)
                        .shadow(color:.gray,radius:2,x:0,y:0)
                }
            case .none:
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color("blue3")  .opacity(0),lineWidth: 3)
                        .frame(width:width,height:height)
                
            }
            
        }//.rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y:1, z: 0))
    }
}

struct CardFront: View {
    let width:CGFloat
    let height:CGFloat
    //let fruitNumber:Int
    //let fruitName:String
    let fruitImage:String
    @Binding var degree: Double
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
                .frame(width:width,height:height)
                .shadow(color:.gray,radius:2,x:0,y:0)
            Image(fruitImage)
            
                
        }.rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y:1, z: 0))
    }
}
struct CardBack: View {
    let width:CGFloat
    let height:CGFloat
    @Binding var degree: Double
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color("blue3").opacity(0.7),lineWidth: 3)
                .frame(width:width,height:height)
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("blue2").opacity(0.2))
                .frame(width:width,height:height)
                .shadow(color:.gray,radius:2,x:0,y:0)

        }.rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y:1, z: 0))
    }
    
    
}

struct ContentView: View {
    @ObservedObject var game: HGViewModel
    @State var backDegree = [0.0,0.0,0.0,0.0]
    @State var frontDegree = [-90.0,-90.0,-90.0,-90.0]
    @State var isFlipped = [false, false, false, false]
    
    // TODO: added width and height to card view so it might be redundant
    let width:CGFloat = 120
    let height:CGFloat = 150
    let durationAndDelay : CGFloat = 0.3
    
    func flipCard(card:Int){
        isFlipped[card] = !isFlipped[card]
        
        if isFlipped[card] {
            withAnimation(.linear(duration:
                durationAndDelay)){
                backDegree[card] = 90
            }
            withAnimation(.linear(duration:
                durationAndDelay)){
                frontDegree[card] = 0
            }
        } else {
            withAnimation(.linear(duration:
                durationAndDelay)){
                frontDegree[card] = -90
            }
            withAnimation(.linear(duration:
                durationAndDelay)){
                backDegree[card] = 0
            }
            
        }
    }
    
    var body: some View{
        ZStack{
            Color("blue0").ignoresSafeArea()
            VStack{
                HStack{
                    Spacer()
                    Button {
                                print("Image tapped!")
                            } label: {
                                Image("back")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            }
                    Spacer(minLength: 150)
                    Button {
                                print("Image tapped!")
                            } label: {
                                Image("replay")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                            }
                    Spacer()
                }
                Spacer()
                ZStack{
                    CardBack(width: width, height: height, degree: $backDegree[3])
                    CardFront(width: width, height: height, fruitImage:"avocado_1",degree: $frontDegree[3])
                }.onTapGesture {flipCard(card:3)}
                
                HStack{
                    Spacer()
                    ZStack{
                        CardBack(width: width, height: height, degree: $backDegree[2])
                        CardFront(width: width, height: height,fruitImage:"avocado_3", degree: $frontDegree[2])
                    }.onTapGesture {flipCard(card:2)}
                    Spacer()
                    ZStack{
                        CardBack(width: width, height: height, degree: $backDegree[1])
                        CardFront(width: width, height: height, fruitImage:"avocado_4",degree: $frontDegree[1])
                    }.onTapGesture {flipCard(card:1)}
                    Spacer()
                    
                }
                
                ZStack{
                    CardView(player: "player", getInfo: game.getCardInfo)
                    //CardBack(width: width, height: height, degree: $backDegree[0])
                    //CardFront(width: width, height: height, fruitImage:"avocado_5",degree: $frontDegree[0])
                }.onTapGesture {game.flip(cardOf: "player")}//flipCard(card:0)}
                
               
                Button {
                            print("bell_1")
                        } label: {
                            Image("bell_1")
                                .resizable()
                                .frame(width: 200, height: 200)
                        }.onTapGesture {game.pressBell("player")}
                Spacer()
            }
            
        }}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = HGViewModel()
        ContentView(game: game)
    }
}

