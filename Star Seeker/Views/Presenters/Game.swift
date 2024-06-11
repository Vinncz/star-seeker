import SpriteKit
import SwiftUI

@Observable class Game : SKScene {
    
    var state         : GameState {
        didSet {
            previousState = oldValue
            switch ( state ) {
                case .playing:
                    self.isPaused = false
                    break
                case .paused:
                    self.isPaused = true
                    break
                case .finished:
                    /* Freeze the game to save memory */
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.isPaused = true
                    }
                default:
                    break
            }
            
            debug("Game state was updated to: \(state)")
        }
    }
    var previousState : GameState = .notYetStarted
    
    override init ( size: CGSize ) {
        self.state = .playing
        
        super.init(size: size)
        
        self.name = NodeNamingConstant.game
        self.scaleMode = .resizeFill
    }
    
    override func didMove ( to view: SKView ) {
        ValueProvider.screenDimension = UIScreen.main.bounds.size
        
        view.allowsTransparency = true
        self.view!.isMultipleTouchEnabled = true
        self.backgroundColor = .clear
        
        attachPlatforms()
        
        let player     = setupPlayer()
        let controller = setupMovementController(for: player)
        addChild(player)
        addChild(controller)
    }
    
    /* Inherited from SKScene. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Game {
    
    func attachPlatforms ( ) {
                
        for i in 0...11 {
            let p2 = BasePlatform( size: ValueProvider.gridDimension )
            p2.position = CGPoint(i, 0)
            addChild(p2)
        }        
        
        for i in 0...11 {
            let p2 = ClimbablePlatform( size: ValueProvider.gridDimension )
            p2.position = CGPoint(i, 5)
            addChild(p2)
        }
        
        for i in 0...11 {
            let p2 = BasePlatform( size: ValueProvider.gridDimension )
            p2.position = CGPoint(i, 2)
            addChild(p2)
        }
        
        for i in 0...7 {
            let p2 = StickyPlatform( size: ValueProvider.gridDimension )
            p2.position = CGPoint(i, 3)
            addChild(p2)
        }        
        
        for i in 8...11 {
            let p2 = BasePlatform( size: ValueProvider.gridDimension )
            p2.position = CGPoint(i, 3)
            addChild(p2)
        }

        for i in 0...3 {
            let p2 = SlipperyPlatform( size: ValueProvider.gridDimension )
            p2.position = CGPoint(i, 4)
            addChild(p2)
        }

    }
}

extension Game {
    
    func setupPlayer () -> Player {
        let player = Player()
        player.position = CGPoint(2, 5)
        
        return player
    }
    
    func setupMovementController ( for target: Player ) -> MovementController {
        let controller = MovementController( controls: target )
        controller.position = CGPoint(2, 2)
        
        return controller
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
