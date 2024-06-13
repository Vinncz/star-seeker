import SpriteKit

class LevelGenerator {
    
    let decipherer : Decipherer
    let target     : SKScene
    
    init ( target : SKScene, decipherer: Decipherer ) {
        self.decipherer = decipherer
        self.target     = target
    }
    
    func generate () {
        let result = (self.decipherer.decipher() as! [[SKSpriteNode?]]).reversed()
        
        for ( rowIndex, row ) in result.enumerated() {
            for ( columnIndex, column ) in row.enumerated() {
                if ( column != nil ) {
                    column!.position = CGPoint(columnIndex, rowIndex)
                    target.addChild(column!)
                }
            }
        }
    }
    
}
