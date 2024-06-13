import SpriteKit
import SwiftData
import SwiftUI

struct ContentView : View {
    @StateObject private var gameControl = GameControl()
    
    var scene : SKScene {
        let scene = Game(size: CGSize(width: 600, height: 400), gameControl: gameControl)
        return scene
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.blue)
                .ignoresSafeArea(.all)
            SpriteView(scene: scene, options: [.allowsTransparency])
                .ignoresSafeArea(.all)
                .background(.clear)
                .onAppear {
                    if let skView = scene.view {
                        skView.showsFPS = true
                        skView.showsNodeCount = true
                    }
                }
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let screenHeight = geometry.size.height
                let columnCount = 11
                let squareSize = screenWidth / CGFloat(columnCount)
                let rowCount = Int(screenHeight / squareSize)
                
                let gridItems = Array(repeating: GridItem(.fixed(squareSize), spacing: 0), count: columnCount)
                let totalItems = columnCount * rowCount
                
                VStack {
                    Spacer()
                    LazyVGrid(columns: gridItems, spacing: 0) {
                        ForEach(0..<totalItems, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color.black, lineWidth: 1)
                                .frame(width: squareSize, height: squareSize)
                        }
                    }
                    .frame(width: screenWidth, height: CGFloat(rowCount) * squareSize)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .disabled(true)
            .opacity(0)
            VStack{
                HStack {
                    Spacer()
                    Button {
                        gameControl.score = 0
                        gameControl.lastPlatformY = 0.0
                    } label:{
                        Text("\(gameControl.score)")
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .font(.largeTitle)
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}


