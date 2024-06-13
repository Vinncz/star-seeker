import SpriteKit
import SwiftUI

@Observable class Game : SKScene, SKPhysicsContactDelegate {
    
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
    var generator     : LevelGenerator?
    var player        : Player?
    
    override init ( size: CGSize ) {
        self.state = .playing
        
        super.init(size: size)
        
        self.name      = NodeNamingConstant.game
        self.scaleMode = .resizeFill
        self.physicsWorld.contactDelegate = self
    }
    
    override func didMove ( to view: SKView ) {
        ValueProvider.screenDimension = UIScreen.main.bounds.size
        
        setup(view)
        attachPlatforms()
        
        self.player     = setupPlayer()
        let controller  = setupMovementController(for: player!)
        addChild(player!)
        addChild(controller)
        
    }
    
    /* Inherited from SKScene. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/** Extension which gives Game the ability to recieve and respond to contact between two physics bodies. */
extension Game {
    
    func didBegin ( _ contact: SKPhysicsContact ) {
        let collision : UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch ( collision ) {
            case BitMaskConstant.player | BitMaskConstant.platform:
                Player.handlePlatformCollision(contact: contact)
                break
                
            case BitMaskConstant.player | BitMaskConstant.darkness:
                // do something
                break
                
            default:
                break
        }
    }
    
    func didEnd ( _ contact: SKPhysicsContact ) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch ( collision ) {
            case BitMaskConstant.player | BitMaskConstant.platform:
                Player.releasePlatformCollision(contact: contact)
                break
                
            default:
                break
        }
    }
    
}

/** Extension which gives Game the ability to setup itself. */
extension Game {
    
    func attachPlatforms () {
        self.generator = LevelGenerator( target: self, decipherer: CSVDecipherer( path: "./LevelFormat2", nodeConfigurations: GameConfig.characterMapping ) )
        self.generator?.generate()
    }
    
    func setup ( _ view: SKView ) {
        view.allowsTransparency = true
        self.view!.isMultipleTouchEnabled = true
        self.backgroundColor = .clear
    }
    
    func setupPlayer () -> Player {
        let player = Player()
        player.position = CGPoint(4, 6)
        
        return player
    }
    
    func setupMovementController ( for target: Player ) -> JoystickMovementController {
        let controller = JoystickMovementController( controls: target )
        controller.position = CGPoint(5, 6)
        
        return controller
    }
}

/** Extension which lets Game track "in what state its in". */
extension Game {
    
    enum GameState {
        case playing,
             paused,
             notYetStarted,
             finished
    }
    
}
