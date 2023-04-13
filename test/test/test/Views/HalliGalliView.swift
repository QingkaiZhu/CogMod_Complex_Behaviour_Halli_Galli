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
                .stroke(Color("blue3").opacity(0.7), lineWidth: 5)
                .frame(width: width, height: height)
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("blue2").opacity(0.2))
                .frame(width: width, height: height)
                .shadow(color: .gray, radius: 2, x: 0, y: 0)
            Image(systemName: "seal.fill")
                .resizable()
                .frame(width:20, height:20)
                .foregroundColor(Color("blue3").opacity(0.7))
            Image(systemName: "seal")
                .resizable()
                .frame(width:40, height:40)
                .foregroundColor(.white)
            Image(systemName: "seal")
                .resizable()
                .frame(width:80, height:80)
                .foregroundColor(Color("blue3").opacity(0.7))
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
    // Add state variables for displaying images
    @State private var showPartyHorn = false
    @State private var showWrongPress = false
    @State var animaDegree = 0.0
    
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
        return  HStack{
            VStack {
                Text("\(player.capitalized)")
                //.font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color("blue3"))
                    .font(.system(size: 15))
                Text("\(score)")
                //.font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("blue3"))
                if player == "model1" || player == "model3"{      Text(game.getEmotion(for: player))
                        .font(.system(size: 24))
                }
            }
            if player == "player" || player == "model2"{
                Text(game.getEmotion(for: player))
                    .font(.system(size: 24))
            }
        }
    }
    
    func setDifficulty(isHardLevel: Bool) {
        if isHardLevel {
            // Set the rt_advantages and flip_interval values for the hard level
            game.model.rt_easystrategy = 1.7 // The values for the hard level
            game.model.rt_generalstrategy = 2.2
            game.model.flip_interval = 3 // The values for the hard level
            game.model.mistake_rate = 30
        } else {
            // Set the rt_advantages and flip_interval values for the easy level
            game.model.rt_easystrategy = 2 // The values for the easy level
            game.model.rt_generalstrategy = 3
            game.model.flip_interval = 4 // The values for the easy level
            game.model.mistake_rate = 50
        }
    }

    
    var body: some View{
        if game.gameOver{
            GameOverView(game: game)
        }
        else {
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
                                .frame(width: 60, height: 60)
                        }
                        Spacer(minLength: 200)
                        Button {
                            print("Image tapped!")
                            game.reset()
                            startCountdown()
                        } label: {
                            Image("replay")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        Spacer()
                    }
                    scoreDisplay(player: "model2")
                    CardView(player: "model2", getInfo:game.getCardInfo)
                    HStack{
                        Spacer()
                        scoreDisplay(player: "model1")
                        CardView(player: "model1", getInfo: game.getCardInfo)
                        CardView(player: "model3", getInfo: game.getCardInfo)
                        scoreDisplay(player: "model3")
                        Spacer()
                    }
                    CardView(player: "player", getInfo: game.getCardInfo)
                        .rotation3DEffect(.degrees(animaDegree), axis: (x: 0, y: 1, z: 0.2))
                        .onTapGesture {
                            if game.isPlayerCardTappable {
                                withAnimation(.interpolatingSpring(stiffness: 20, damping: 5)) {
                                    self.animaDegree += 360}
                                game.isBellTappable = true
                                game.model.anticipationAnalysisHard()
                                game.model.anticipationAnalysisEasy()
                                game.flip(cardOf: "player")
                                game.model.computeRt(for: "model1", isHardLevel: game.isHardLevel)
                                game.model.computeRt(for: "model2", isHardLevel: game.isHardLevel)
                                game.model.computeRt(for: "model3", isHardLevel: game.isHardLevel)
                                let isModelPressed = game.modelPress()
                                game.flipCardsAutomatically()
                            }
                        }
                    scoreDisplay(player: "player")
                    ZStack{
                        //                    if showPartyHorn {
                        //                        Image("party_horn")
                        //                            .resizable()
                        //                            .frame(width: 180, height: 170)
                        //                            .offset(x: 0, y: -200)
                        //                    }
                        //
                        //                    if showWrongPress {
                        //                        Image("wrongpress")
                        //                            .resizable()
                        //                            .frame(width: 180, height: 170)
                        //                            .offset(x: 0, y: -200)
                        //                    }
                        Button{
                            if game.isBellTappable{
                                game.isBellTappable = false
                                let isCorrect = game.pressBell("player")
                                print("player pressed the bell by a \(isCorrect) decision")
                                if isCorrect {
                                    showPartyHorn = true
                                } else {
                                    showWrongPress = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    showPartyHorn = false
                                    showWrongPress = false
                                }
                            }
                        } label: {
                            Image("bell_2")
                                .resizable()
                                .frame(width: 180, height: 160)
                        }
                    }
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
                setDifficulty(isHardLevel: game.isHardLevel)
            })
            .onReceive(game.$gameOver, perform: { isGameOver in
                if isGameOver {
                    game.model.endGame(isGameOver: isGameOver)
                    game.winner = game.model.winner
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = HGViewModel()
        ContentView(game: game)
    }
}

