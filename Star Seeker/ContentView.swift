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
            if ( scene.state == .paused ) { PauseScreen() }
            Text("\(scene.player?.statistics.highestPlatform.y ?? 0)m")
                .font(.title)
                .bold()
                .foregroundStyle(.white)
            PlayPauseButton()
            CountdownBeforeResuming()
        }
    }    
    
    let sw = UIScreen.main.bounds.width
    let sh = UIScreen.main.bounds.height
    
    @State var scene : Game = Game(size: UIScreen.main.bounds.size)
    @State var stopwatch : CountdownTimer?
}

extension ContentView {
    
    func CountdownBeforeResuming () -> some View {
        if ( self.stopwatch != nil ) {
            AnyView (
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text(String((stopwatch?.remainingTime ?? -1) + 1))
                            .font(.system(size: UIConfig.FontSizes.astronomical))
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
                self.stopwatch = CountdownTimer(duration: 2, action: { 
                    game.state = .playing
                    self.stopwatch?.end()
                    self.stopwatch = nil
                })
                self.stopwatch?.begin()
            }
        } label: {
            let game = self.scene
            if ( game.state == .playing ) {
                Image(systemName: "pause.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding()
            } else if ( game.state == .paused ) {
                Image(systemName: "play.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding()
            }
        }
    }
    
}

#Preview {
    ContentView()
}
