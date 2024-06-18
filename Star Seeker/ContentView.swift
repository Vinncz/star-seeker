import SpriteKit
import SwiftData
import SwiftUI

struct ContentView : View {
    
    var body: some View {
        ZStack ( alignment: .topLeading ) {
            Rectangle()
                .foregroundStyle(.blue)
                .ignoresSafeArea(.all)
            SpriteView(scene: scene, options: [.allowsTransparency])
                .ignoresSafeArea(.all)
                .background(.clear)
            //            GridScreen()
            HStack {
                PlayPauseButton().font(.largeTitle).foregroundStyle(.white)
                Spacer()
                PlayerScore()
            }
            .padding()
            if ( scene.state == .paused ) { PauseScreen().background(.black.opacity(0.5)) }
            if ( scene.state == .finished ) { EndScreen().background(.black.opacity(0.5)) }
            EndScreen().background(.black.opacity(0.5))
        }
    }
    
    let sw = UIScreen.main.bounds.width
    let sh = UIScreen.main.bounds.height
    
    @State var scene : Game = Game(size: UIScreen.main.bounds.size)
    @State var stopwatch : CountdownTimer?
    @State var gameIsTransitioningToPlaying : Bool = false
    @State var playerScoreScalingFactor : Double = 1.0
}

/* MARK: -- Extension which provides ContentView with file-specific visual components */
extension ContentView {
    
    func RestartButton () -> some View {
        Button {
            scene.restart()
        } label: {
            Image("pause-reset-button")
                .resizable()
                .scaledToFit()
                .frame(width: 80)
        }
    }
    
    func PlayerScore () -> some View {
        withAnimation {
            Text(String(format: "%.0fm", scene.player?.statistics!.currentHeight.y ?? 0))
                .scaleEffect(playerScoreScalingFactor)
                .font(.system(.title, design: .rounded))
                .bold()
                .foregroundStyle(.white)
                .animation(.bouncy(duration: 0.1), value: playerScoreScalingFactor)
                .onChange(of: scene.player?.statistics!.currentHeight.y) { oldValue, newValue in
                    playerScoreScalingFactor = 1.25
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3){
                        playerScoreScalingFactor = 1.0
                    }
                }
        }
    }
    
    func CountdownBeforeResuming () -> some View {
        if ( self.stopwatch != nil ) {
            AnyView (
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text(String((stopwatch?.remainingTime ?? -1) + 1))
                            .font(.custom("Chainwhacks", size: UIConfig.FontSizes.titanic))
                            .bold()
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    Spacer()
                }
            )
        } else {
            AnyView (
                EmptyView()
            )
        }
    }
    
    func PlayPauseButton () -> some View {
        return Button {
            let game = self.scene
            if ( game.state == .playing ) {
                game.state = .paused
            } else if ( game.state == .paused ) {
                self.gameIsTransitioningToPlaying = true
                self.stopwatch = CountdownTimer(duration: 2, action: {
                    game.state = .playing
                    self.stopwatch?.end()
                    self.stopwatch = nil
                    self.gameIsTransitioningToPlaying = false
                })
                self.stopwatch?.begin()
            }
        } label: {
            let game = self.scene
            if ( game.state == .playing || game.state == .notYetStarted ) {
                Image(systemName: "pause.circle.fill")
            } else if ( game.state == .paused ) {
                Image(systemName: "play.circle.fill")
            }
        }
    }
    
    func PauseScreen () -> some View {
        if ( self.gameIsTransitioningToPlaying == false ) {
            AnyView (
                VStack {
                    Spacer()
                    ZStack {
                        Image("pause-box")
                            .resizable()
                            .scaledToFit()
                        VStack (spacing: UIConfig.Spacings.large) {
                            Text("Paused")
                                .font(.custom("Chainwhacks", size: UIConfig.FontSizes.normal))
                                .foregroundStyle(.black)
                                .opacity(0.2)
                            HStack (spacing: UIConfig.Spacings.huge) {
                                RestartButton()
                                Button {
                                    let game = self.scene
                                    self.gameIsTransitioningToPlaying = true
                                    self.stopwatch = CountdownTimer(duration: 2, action: {
                                        game.state = .playing
                                        self.stopwatch?.end()
                                        self.stopwatch = nil
                                        self.gameIsTransitioningToPlaying = false
                                    })
                                    self.stopwatch?.begin()
                                } label: {
                                    Image("pause-play-button")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80)
                                }
                            }
                        }
                        
                    }
                    .frame(width: .infinity)
                    Spacer()
                }
                    .padding(.horizontal, UIConfig.Spacings.huge)
                    .frame(width: .infinity, height: .infinity)
            )
        } else {
            AnyView (
                CountdownBeforeResuming()
            )
        }
    }
    
    func EndScreen () -> some View {
        withAnimation {
            //            HStack ( alignment: .center ) {
            //                Spacer()
            //                VStack {
            //                    Spacer()
            //                    VStack ( spacing: UIConfig.Spacings.large ) {
            //                        Text("GAME OVER")
            //                            .bold()
            //                            .font(.system(.largeTitle, design: .rounded))
            //                        VStack {
            //                            Text("You managed to reach")
            //                                .font(.system(.body, design: .rounded))
            //                            Text(String(format: "%.0fm", scene.player?.statistics!.highestPlatform.y ?? 0))
            //                                .font(.system(.largeTitle, design: .rounded))
            //                                .bold()
            //                                .rotationEffect(.degrees(7))
            //                        }
            //                        RestartButton().font(.system(size: UIConfig.FontSizes.huge))
            //                    }
            //                    .padding(.horizontal, UIConfig.Paddings.huge)
            //                    .padding(.vertical, UIConfig.Paddings.huge)
            //                    .background (
            //                        .white,
            //                        in: RoundedRectangle(cornerRadius: UIConfig.CornerRadiuses.huge)
            //                    )
            //                    Spacer()
            //                }
            //                Spacer()
            //            }
            //            .foregroundStyle(.gray)
            
            VStack {
                Spacer()
                ZStack {
                    Image("pause-box")
                        .resizable()
                        .scaledToFit()
                    VStack (spacing: UIConfig.Spacings.large) {
                        VStack (spacing: UIConfig.Spacings.nano){
                            Text(String(format: "%.0fm", scene.player?.statistics!.highestPlatform.y ?? 0))
                                .font(.custom("Chainwhacks", size: UIConfig.FontSizes.normal))
                                .foregroundStyle(.black)
                            
                            Text("Hi Score: \(String(format: "%.0fm", scene.player?.statistics!.highestPlatform.y ?? 0))")
                                .font(.custom("Chainwhacks", size: UIConfig.FontSizes.micro))
                                .foregroundStyle(.gray)
                        }
                        RestartButton()
                    }
//                    VStack {
//                        Text("Game")
//                        Text("Over")
//                    }
                    
                }
                .frame(width: .infinity)
                Spacer()
            }
            .padding(.horizontal, UIConfig.Spacings.huge)
            .frame(width: .infinity, height: .infinity)
        }
    }
}

#Preview {
    ContentView()
}
