//
//  ContentView.swift
//  HalliGalli
//
//  Created by 王超仪 on 04/03/2023.
//

import SwiftUI

// TODO: bugs in the socre
/// This view displays a card with the provided information (a card object and a flipped state). It can display both the front and back of the card based on the isFlipped property.
struct CardView: View {
    let card: Card?
    let isFlipped: Bool
    let width: CGFloat = 120
    let height: CGFloat = 150

    init(player: String, getInfo: (String) -> (Card?, Bool)) {
        (card, isFlipped) = getInfo(player)
    }

    var body: some View {
        ZStack {
            CardBack(width: width, height: height)
                .opacity(isFlipped ? 0 : 1)
            CardFront(card: card, width: width, height: height)
                .opacity(isFlipped ? 1 : 0)
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0),
            anchor: .center,
            anchorZ: 0.0,
            perspective: 0.5
        )
    }
}

struct CardFront: View {
    let card: Card?
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            if let card = card {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white)
                    .frame(width: width, height: height)
                    .shadow(color: .gray, radius: 2, x: 0, y: 0)
                Image(String(card.id))
            }
        }
    }
}

struct CardBack: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color("blue3").opacity(0.7), lineWidth: 3)
                .frame(width: width, height: height)
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("blue2").opacity(0.2))
                .frame(width: width, height: height)
                .shadow(color: .gray, radius: 2, x: 0, y: 0)
        }
    }
}



struct ContentView: View {
    @ObservedObject var game: HGViewModel
    @State var backDegree = [0.0,0.0,0.0,0.0]
    @State var frontDegree = [-90.0,-90.0,-90.0,-90.0]
    @State var isFlipped = [false, false, false, false]
    @State private var countdown: Int? = 3
    @State private var showCountdown = true
    
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
    
    func startCountdown() {
            showCountdown = true
            countdown = 3
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if countdown! > 1 {
                    countdown! -= 1
                } else {
                    timer.invalidate()
                    showCountdown = false
                }
            }
    }
    
    func scoreDisplay(player: String) -> some View {
        let score = game.getScore(for: player)
        return VStack {
            Text("\(player.capitalized)")
                //.font(.headline)
                .foregroundColor(.red)
            Text("\(score)")
                //.font(.largeTitle)
                .foregroundColor(.red)
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
                        game.showHGView = false
                    } label: {
                        Image("back")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    Spacer(minLength: 150)
                    Button {
                        print("Image tapped!")
                        game.reset()
                        startCountdown()
                    } label: {
                        Image("replay")
                            .resizable()
                            .frame(width: 70, height: 70)
                    }
                    Spacer()
                }
                Spacer()
                scoreDisplay(player: "model2")
                ZStack{
                    CardView(player: "model2", getInfo:
                                game.getCardInfo)
                }
                HStack{
                    Spacer()
                    scoreDisplay(player: "model1")
                    ZStack{
                        CardView(player: "model1", getInfo: game.getCardInfo)
                    }
                    Spacer()
                    ZStack{
                        CardView(player: "model3", getInfo: game.getCardInfo)
                    }
                    scoreDisplay(player: "model3")
                    Spacer()
                }
                ZStack{
                    CardView(player: "player", getInfo: game.getCardInfo)
                }.onTapGesture {
                    if game.isPlayerCardTappable {
                        game.flip(cardOf: "player")
                        game.flipCardsAutomatically()
                                        }
                }
                scoreDisplay(player: "player")
                // TODO: bug: empty card
                Button{
                    print("bell_1")
                    game.pressBell("player")
                } label: {
                    Image("bell_1")
                        .resizable()
                        .frame(width: 200, height: 200)
                }
                Spacer()
            }
            if showCountdown {
                VStack {
                    Text(countdown == 0 ? "Start" : "\(countdown!)")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .bold()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.4))
                .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear(perform: {
            startCountdown()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = HGViewModel()
        // Use a dummy binding
        ContentView(game: game)
    }
}

