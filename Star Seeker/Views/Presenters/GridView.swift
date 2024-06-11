import SwiftUI

struct GridScreen : View {
    var body : some View {
        GeometryReader { geometry in
            let screenWidth  = geometry.size.width
            let screenHeight = geometry.size.height
            let columnCount  : Int = Int(GameConfig.playArea.width)
            let squareSize   = screenWidth / CGFloat(columnCount)
            let rowCount     = Int(screenHeight / squareSize)
            
            let gridItems = Array(repeating: GridItem(.fixed(squareSize), spacing: 0), count: columnCount)
            let totalItems = columnCount * rowCount
            
            VStack {
                Spacer()
                LazyVGrid(columns: gridItems, spacing: 0) {
                    ForEach(0..<totalItems, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(.white.opacity(0.25), lineWidth: 1)
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
