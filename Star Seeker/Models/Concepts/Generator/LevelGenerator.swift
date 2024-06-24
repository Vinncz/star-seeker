import SpriteKit

class LevelGenerator {
    let decipherer : [Decipherer]
    let target     : SKScene
    
    init ( for target : SKScene, decipherer: [Decipherer] ) {
        self.decipherer = decipherer
        self.target     = target
    }
    
    func generate () {
        self.decipherer.forEach { decipherer in
            let decipheredResult = decipherer.decipher() as! ([[SKSpriteNode?]], (any Error)?)
            let usableResult     = decipheredResult.0.reversed()
            
            debug("<< generator error: " + decipheredResult.1.debugDescription + " >>")
            
            for ( rowIndex, row ) in usableResult.enumerated() {
                for ( columnIndex, column ) in row.enumerated() {
                    if let nodeAtHand = column {
                        nodeAtHand.position = CGPoint(columnIndex, rowIndex)
                        target.addChild(nodeAtHand)
                    }
                }
            }
        }
    }
}
