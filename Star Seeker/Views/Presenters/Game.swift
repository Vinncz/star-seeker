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
        
        let player     = setupPlayer()
        let controller = setupMovementController(for: player)
        addChild(player)
        addChild(controller)
        
    }
    
    func didBegin ( _ contact: SKPhysicsContact ) {
        let collision : UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch ( collision ) {
            case NodeCategory.player.bitMask | NodeCategory.platform.bitMask:
                let player : SKNode
                let platform : SKNode
                
                if (contact.bodyA.node!).name == NodeNamingConstant.player {
                    player = contact.bodyA.node!
                    platform = contact.bodyB.node!
                } else {
                    player = contact.bodyB.node!
                    platform = contact.bodyA.node!
                }
                
                handleCollisionBetweenPlayerAndPlatform( player: player as! SKSpriteNode, platform: platform as! SKSpriteNode )
                
                break
                
            default:
                break
        }
    }
    
    /* Inherited from SKScene. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Game {
    
    func handleCollisionBetweenPlayerAndPlatform ( player: SKSpriteNode, platform: SKSpriteNode ) {
        switch ( platform.name ) {
            case NodeNamingConstant.Platform.Inert.base:
                print("player is on base")
                (player as! Player).state = .idleLeft
                break
            case NodeNamingConstant.Platform.Inert.Dynamic.moving:
                print("player is on moving")
                break
            case NodeNamingConstant.Platform.Inert.Dynamic.collapsible:
                print("player is on collapsible")
                break
            case NodeNamingConstant.Platform.Reactive.slippery:
                print("player is on slippery")
                (player as! Player).state = .idleLeft
                break
            case NodeNamingConstant.Platform.Reactive.sticky:
                print("player is on sticky")
                (player as! Player).state = .idleLeft
                break
            default:
                print("player is on \(platform.name) --")
                break
        }
    }
    
}

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
    
}

extension Game {
    
    func setupPlayer () -> Player {
        let player = Player()
        player.position = CGPoint(4, 6)
        
        return player
    }
    
    func setupMovementController ( for target: Player ) -> JoystickMovementController {
        let controller = JoystickMovementController( controls: target )
        controller.position = CGPoint(5, 4)
        
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
