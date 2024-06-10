import SpriteKit
import SwiftUI

class Game : SKScene {
    
    var state         : GameState {
        didSet {
            previousState = oldValue
        }
    }
    var previousState : GameState = .notYetStarted
    
    override init ( size: CGSize ) {
        self.state = .notYetStarted
        
        super.init(size: size)
        
        self.name = NodeNamingConstant.game
        self.scaleMode = .resizeFill
    }
    
    override func didMove ( to view: SKView ) {
        view.allowsTransparency = true
        self.view!.isMultipleTouchEnabled = true
        self.backgroundColor = .clear
    }
    
    /* Inherited from SKScene. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Game {
    
    enum GameState {
        case playing,
             paused,
             notYetStarted,
             finished
    }
    
}
