import SpriteKit
import SwiftData
import SwiftUI

struct ContentView : View {
    
    var body: some View {
        ZStack ( alignment: .topLeading ) {
            Image(ImageNamingConstant.Background.Autumn.background)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all)
            SpriteView(scene: scene, options: [.allowsTransparency])
                .ignoresSafeArea(.all)
                .background(.clear)
            //            GridScreen()
            HStack {
                PauseButton().font(.largeTitle).foregroundStyle(.white)
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
            Image("reset-button")
                .resizable()
                .scaledToFit()
                .frame(width: 80)
        }
    }
    
    func ExitButton () -> some View {
        Button {
            print("go to start screen")
        } label: {
            Image("exit-button")
                .resizable()
                .scaledToFit()
                .frame(width: 80)
        }
    }
    
    func PlayButton () -> some View {
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
            Image("play-button")
                .resizable()
                .scaledToFit()
                .frame(width: 80)
        }
    }
    
    func PauseButton () -> some View {
        Button {
            let game = self.scene
            if ( game.state == .playing ) {
                game.state = .paused
            }
        } label: {
            Image("pause-button")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
        }
    }
    
    func PlayerScore () -> some View {
        withAnimation {
            StrokeText(text: String(format: "%.0fm", scene.player?.statistics!.currentHeight.y ?? 0), width: 0.5, borderColor: .black, size: UIConfig.FontSizes.mini, foregroudColor: .white)
                .scaleEffect(playerScoreScalingFactor)
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
                                PlayButton()
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
                                .foregroundStyle(Color(hue: 0, saturation: 0, brightness: 0.37))
                            Text("Hi Score: \(String(format: "%.0fm", scene.player?.statistics!.highestPlatform.y ?? 0))")
                                .font(.custom("Chainwhacks", size: UIConfig.FontSizes.micro))
                                .foregroundStyle(.gray)
                        }
                        HStack (spacing: UIConfig.Spacings.large) {
                            RestartButton()
                            ExitButton()
                        }
                    }
                    .padding(.top, 20)
                    VStack (spacing: 0) {
                        StrokeText(text: "Game", width: 2, borderColor: .black, size: UIConfig.FontSizes.normal, foregroudColor: .white)
                            .offset(y: 10)
                        StrokeText(text: "Over", width: 2, borderColor: .black, size: UIConfig.FontSizes.colossal, foregroudColor: .white)
                    }
                    .offset(y: -160)
                    
                    
                }
                .frame(width: .infinity)
                Spacer()
            }
            .padding(.horizontal, UIConfig.Spacings.huge)
            .frame(width: .infinity, height: .infinity)
        }
    }
}

struct StrokeText: View {
    let text: String
    let width: CGFloat
    let borderColor: Color
    let size: CGFloat
    let foregroudColor: Color
    
    var body: some View {
        ZStack{
            ZStack{
                Text(text).offset(x:  width, y:  width)
                    .font(.custom("Chainwhacks", size: size))
                Text(text).offset(x: -width, y: -width)
                    .font(.custom("Chainwhacks", size: size))
                Text(text).offset(x: -width, y:  width)
                    .font(.custom("Chainwhacks", size: size))
                Text(text).offset(x:  width, y: -width)
                    .font(.custom("Chainwhacks", size: size))
            }
            .foregroundColor(borderColor)
            Text(text)
                .font(.custom("Chainwhacks", size: size))
                .foregroundColor(foregroudColor)
        }
    }
}

#Preview {
    ContentView()
}
