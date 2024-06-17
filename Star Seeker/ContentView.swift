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
            GridScreen()
            HStack {
                PlayPauseButton().font(.largeTitle).foregroundStyle(.white)
                RestartButton().font(.largeTitle).foregroundStyle(.white)
                Spacer()
                PlayerScore()
            }
                .padding()
            if ( scene.state == .paused ) { PauseScreen().background(.black.opacity(0.5)) }
            if ( scene.state == .finished ) { EndScreen().background(.black.opacity(0.5)) }
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
            Image(systemName: "arrow.counterclockwise.circle.fill")
        }
    }
    
    func PlayerScore () -> some View {
        withAnimation {
            Text(String(format: "%.0fm", scene.player?.statistics!.highestPlatform.y ?? 0))
                .scaleEffect(playerScoreScalingFactor)
                .font(.system(.title, design: .rounded))
                .bold()
                .foregroundStyle(.white)
                .animation(.bouncy(duration: 0.1), value: playerScoreScalingFactor)
                .onChange(of: scene.player?.statistics!.highestPlatform.y) { oldValue, newValue in
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
                            .font(.system(size: UIConfig.FontSizes.astronomical, design: .rounded))
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
                HStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            VStack ( spacing: UIConfig.Spacings.normal ) {
                                Text("Paused")
                                    .font(.system(.largeTitle, design: .rounded))
                                    .bold()
                                    .foregroundStyle(.gray)
                                HStack () {
                                    PlayPauseButton()
                                        .foregroundStyle(.gray)
                                        .font(.system(size: 64))
                                    RestartButton()
                                        .foregroundStyle(.gray)
                                        .font(.system(size: 64))
                                }
                            }
                                .padding()
                                .frame(width: 320)
                                .background(
                                    Color(red: 255, green: 208, blue: 193),
                                    in: RoundedRectangle(cornerRadius: 16)
                                )
                            Spacer()
                        }
                            .padding()
                        Spacer()
                    }
                    Spacer()
                }
            )
            
        } else {
            AnyView (
                CountdownBeforeResuming()
            )
        }
    }
    
    func EndScreen () -> some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("Game Over")
                    .bold()
                    .font(.system(.largeTitle, design: .rounded))
                    .foregroundStyle(.white)
                RestartButton().font(.largeTitle).foregroundStyle(.white)
                Spacer()
            }
                .padding()
            Spacer()
        }
    }
    
}

#Preview {
    ContentView()
}
