import SpriteKit
import SwiftData
import SwiftUI

struct ContentView : View {
    @StateObject private var gameControl = GameControl()
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.blue)
                .ignoresSafeArea(.all)
            SpriteView(scene: Game(size: CGSize(width: 600, height: 400), gameControl: gameControl), options: [.allowsTransparency])
                .ignoresSafeArea(.all)
                .background(.clear)
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
        }
    }
}

#Preview {
    ContentView()
}


