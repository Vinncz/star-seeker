import SpriteKit
import SwiftData
import SwiftUI

struct ContentView : View {
    @State private var viewModel = ContentViewModel(scene: "art.scnassets/tower.scn")
    
    var scview : SceneKitView {
        SceneKitView(scene: viewModel.scene)
    }
    
    var body: some View {
        ZStack ( alignment: .topLeading ) {
            scview
                .edgesIgnoringSafeArea(.all)
            SpriteView(scene: game, options: [.allowsTransparency])
                .ignoresSafeArea(.all)
                .background(.clear)
            if ( game.state == .notYetStarted ) {
                StartScreen()
            } else {
                HStack {
                    PauseButton().font(.largeTitle).foregroundStyle(.white)
                    Spacer()
                    PlayerScore()
                }
                    .padding()
            }
            if ( game.state == .paused ) { PauseScreen().background(.black.opacity(0.5)) }
            if ( game.state == .finished ) { 
                EndScreen().background(.black.opacity(0.5)) 
                doSomething {
                    viewModel.resetTowerPosition()
                }
            }
            if ( game.state == .levelChange ) { doSomething({
                guard ( viewModel.state != .progressing ) else { return }
                viewModel.handleSwipe()
                game.state = .awaitingTransitionFinish
                if ( game.themeShouldChange() ) {
                    var a = game.prepareCloudTransition()
                    game.rehearseCloudTransition(&a)
                    game.run(.wait(forDuration: 3)) {
                        game.performCloudTransition(a)
                    }
                    // TODO: - Refactor these logic, so it reside within the Game
                    if let currentIndex = game.themeSequence.firstIndex(of: game.currentTheme) {
                        let nextIndex = (currentIndex + 1) % game.themeSequence.count
                        game.currentTheme = game.themeSequence[nextIndex]
                    }
                    game.levelTrack = 1
                    game.run(.wait(forDuration: 3.5)) {
                        let ts : TowerSeason
                        switch ( game.currentTheme ) {
                            case .autumn:
                                ts = .autumn
                            case .winter:
                                ts = .winter
                            case .spring:
                                ts = .spring
                            case .summer:
                                ts = .summer
                            default:
                                ts = .autumn
                        }
                        viewModel.changeToSeason(ts)
                    }
                }
            }) }
            if ( viewModel.state == .finished ) { doSomething({
                game.proceedWithGeneratingNewLevel()
                viewModel.state = .ready
            }) }
        }
    }
    
    let sw = UIScreen.main.bounds.width
    let sh = UIScreen.main.bounds.height
    
    func background () -> String {
        switch ( game.currentTheme ) {
            case .autumn:
                return ImageNamingConstant.Background.Autumn.background
            case .winter:
                return ImageNamingConstant.Background.Winter.background
            case .spring:
                return ImageNamingConstant.Background.Spring.background
            case .summer:
                return ImageNamingConstant.Background.Summer.background
            default:
                return ImageNamingConstant.Background.Autumn.background
        }
    }
    @State var game : Game = Game(size: UIScreen.main.bounds.size)
    @State var stopwatch : CountdownTimer?
    @State var gameIsTransitioningToPlaying : Bool = false
    @State var playerScoreScalingFactor : Double = 1.0
    @State var tapToStartScale: CGFloat = 1.0
}

/* MARK: -- Extension which provides ContentView with file-specific visual components */
extension ContentView {
    
    func StartScreen () -> some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                HStack {
                    Image(ImageNamingConstant.Interface.Screen.startTitle)
                        .resizable()
                        .scaledToFit()
                }
                .padding(.top, 40)
                .frame(width: .infinity)
                Spacer()
                StrokeText(text: "Tap To Play", width: 3, borderColor: .black.opacity(0.5), size: UIConfig.FontSizes.mini, foregroudColor: .white)
                    .padding(.bottom, 120)
                    .scaleEffect(tapToStartScale, anchor: .top)
                    .onAppear {
                        self.tapToStartScale = 1.0
                        withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                            self.tapToStartScale = 1.1
                        }
                    }
                Spacer()
            }
                .onTapGesture {
                    self.game.perform()
                }
            Spacer()
        }
            .background(.black.opacity(0.6))
    }
    
    func doSomething ( _ command: () -> Void ) -> some View {
        command()
        return EmptyView()
    }
    
    func RestartButton () -> some View {
        Button {
            game.restart()
        } label: {
            Image("reset-button")
                .resizable()
                .scaledToFit()
                .frame(width: 80)
        }
    }
    
    func ExitButton () -> some View {
        Button {
            debug("go to start screen")
        } label: {
            Image("exit-button")
                .resizable()
                .scaledToFit()
                .frame(width: 80)
        }
    }
    
    func PlayButton () -> some View {
        Button {
            let game = self.game
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
            let game = self.game
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
            let playerSideScore = (game.player?.statistics!.currentHeight.y ?? 0) - (game.player?.statistics!.spawnPosition.y ?? 0)
            let sceneSideScore  = game.statistics.accumulativeScore
            let shownScore      = playerSideScore + sceneSideScore
            
            return StrokeText(text: String(format: "%.0fm", shownScore), width: 0.5, borderColor: .black, size: UIConfig.FontSizes.mini, foregroudColor: .white)
                .scaleEffect(playerScoreScalingFactor)
                .animation(.bouncy(duration: 0.1), value: playerScoreScalingFactor)
                .onChange(of: game.player?.statistics!.currentHeight.y) { oldValue, newValue in
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
            let highestPlayerSideScore = (game.player!.statistics!.highestPlatform.y) - (game.player!.statistics!.spawnPosition.y)
            let sceneSideScore  = game.statistics.accumulativeScore
            let currentPlayerSideScore = (game.player!.statistics!.currentHeight.y) - (game.player!.statistics!.spawnPosition.y)
            let currHeightScore = sceneSideScore + currentPlayerSideScore
            let maxScore        = highestPlayerSideScore + sceneSideScore
            
            return VStack {
                Spacer()
                ZStack {
                    Image("pause-box")
                        .resizable()
                        .scaledToFit()
                    VStack (spacing: UIConfig.Spacings.large) {
                        VStack (spacing: UIConfig.Spacings.nano){
                            Text(String(format: "%.0fm", currHeightScore))
                                .font(.custom("Chainwhacks", size: UIConfig.FontSizes.normal))
                                .foregroundStyle(Color(hue: 0, saturation: 0, brightness: 0.37))
                            Text("You did reach: \(String(format: "%.0fm", maxScore))")
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
                .frame(maxWidth: .infinity)
                Spacer()
            }
            .padding(.horizontal, UIConfig.Spacings.huge)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
