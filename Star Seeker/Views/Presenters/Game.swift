import SpriteKit
import SwiftUI

/// An object that organizes all of the active SpriteKit content contained within it.
/// 
/// ## Overview
/// Game, as the name suggest, is the location of where everything happen.
/// To display and interact with the game, you present an instance of this, inside an SKView from a SwiftUI file.
/// 
/// ## Transparency
/// Game uses a state, levelTrack, theme, and themedLevel to indicate "in what state they are", and "what matters the most now".
@Observable class Game : SKScene, SKPhysicsContactDelegate {
    
    override init ( size: CGSize ) {
        self.state = .playing
        
        super.init(size: size)
        
        self.name      = NodeNamingConstant.game
        self.scaleMode = .resizeFill
        self.physicsWorld.contactDelegate = self
    }
    
    /** Called after an instace of Game is ready to be shown at some SKView instance. */
    override func didMove ( to view: SKView ) {
        ValueProvider.screenDimension = UIScreen.main.bounds.size
        
        setup(view)
        levelDidLoad()
        
        self.player      = try? findPlayerElement()
        self.controller  = setupMovementController(for: self.player!)
        
        attachDarkness()
        
        self.outboundIndicator = setupOutboundIndicator()
        
        addChild(outboundIndicator!)
        addChild(controller!)
        
        playAnimation()
    }
    
    /** The state of situation for self */
    var state         : GameState {
        didSet {
            previousState = oldValue
            
            switch ( state ) {
                case .playing:
                    self.isPaused = false
                case .paused:
                    self.isPaused = true
                case .finished:
                    let slowDownAction = SKAction.customAction(withDuration: 6) { _, elapsedTime in
                        let progress = elapsedTime / 6
                        self.speed = 1 - progress
                    }
                    self.run(slowDownAction, withKey: ActionNamingConstant.gameSlowingDown)
                default:
                    break
            }
            
            debug("Game state was updated to: \(state)")
        }
    }
    /** The previous state of self */
    var previousState : GameState = .notYetStarted
    /** An instance of generator object which renders the needed level to the scene. Level generator object persists between game resets */
    var generator     : LevelGenerator?
    /** An instance of SKNode which represents the player in game. Player object does not persist between game resets */
    var player        : Player?
    /** An instance of SKNode which controls another SKNode. Controller object persists between game resets, but require its target attribute to be updated to the new target */
    var controller    : MovementController?
    
    var levelTrack    : Int  = 1
    var currentTheme  : Season = .autumn
    var themedLevels  : Bool = true
    
    var outboundIndicator: SKSpriteNode?
    var currentMovingPlatform: SKSpriteNode?
    var currentMovingPlatformPosition: CGPoint?

    /* Inherited from SKScene. Refrain from altering the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/* MARK: -- Extension which gives Game the ability to recieve and respond to contact between two physics bodies within its physicsWorld. */
extension Game {
    
    override func update ( _ currentTime: TimeInterval ) {
        if let platform = currentMovingPlatform {
            if let previousPosition = currentMovingPlatformPosition {
                let deltaX = platform.position.x - previousPosition.x
                currentMovingPlatformPosition = platform.position
                if let player {
                    player.position.x += deltaX
                }
            } else {
                currentMovingPlatformPosition = currentMovingPlatform?.position
            }
        }
        
        guard let playerPosition = self.player?.position, let outboundIndicatorNode = self.outboundIndicator else {
            fatalError("player and outbound indicator not found")
        }
        let isPlayerOutbound = playerPosition.x < 0 || playerPosition.x > ValueProvider.screenDimension.width || playerPosition.y > ValueProvider.screenDimension.height
        if isPlayerOutbound {
            let indicatorVerticalOffset = outboundIndicatorNode.size.width / 2
            let indicatorHeightOffset = outboundIndicatorNode.size.height / 2
            outboundIndicatorNode.isHidden = false
            if (playerPosition.y < ValueProvider.screenDimension.height){
                if (playerPosition.x < ValueProvider.screenDimension.width / 2) {
                    outboundIndicatorNode.position = CGPoint(x: 0 + indicatorVerticalOffset, y: playerPosition.y)
                    outboundIndicatorNode.zRotation = 1.6
                } else {
                    outboundIndicatorNode.position = CGPoint(x: ValueProvider.screenDimension.width - indicatorVerticalOffset, y: playerPosition.y)
                    outboundIndicatorNode.zRotation = -1.6
                }
            } else {
                outboundIndicatorNode.position = CGPoint(x: playerPosition.x, y: ValueProvider.screenDimension.height - indicatorHeightOffset)
                outboundIndicatorNode.zRotation = 0
            }
        } else {
            outboundIndicatorNode.isHidden = true
        }
    }
    
    /** Called after an instace of SKPhysicsBody collided with another instance of SKPhysicsBody inside self's physicsWorld attribute. Their contactBitMask attribute must match the bitwise operation "OR" in order for this method to be called. */
    func didBegin ( _ contact: SKPhysicsContact ) {
        let collisionHandlers : [Set<UInt32>: (SKPhysicsContact, (Player) -> Void) -> Void] = [
            [BitMaskConstant.player, BitMaskConstant.platform]: { contact, completion in
                Player.intoContactWithPlatform(contact: contact, completion: completion)
            },
            [BitMaskConstant.player, BitMaskConstant.levelChangePlatform]: { contact, completion in
                let command : ( Player ) -> Void = { player in
                    self.advanceToNextLevel()
                }
                Player.intoContactWithPlatform(contact: contact, completion: command)
            },
            [BitMaskConstant.player, BitMaskConstant.movingPlatform]: { contact, completion in
                let command : (Player) -> Void = { player in
                    let nodes = UniversalNodeIdentifier.identify (
                        checks: [
                            { $0 as? Player },
                            { $0 as? MovingPlatform },
                        ], 
                        contact.bodyA.node!, 
                        contact.bodyB.node!
                    )
                    if let player = nodes[0] as? Player, let platform = nodes[1] as? MovingPlatform {
                        if ( self.currentMovingPlatform == nil ) {
                            self.currentMovingPlatform = platform
                        } 
                    }
                }
                Player.intoContactWithPlatform(contact: contact, completion: command)
            },
            [BitMaskConstant.player, BitMaskConstant.darkness]: { contact, completion in 
                if ( self.state != .finished ) {
                    self.state = .finished
                }
                Player.intoContactWithDarkness(contact: contact, completion: completion)
            }
        ]
        let collision         = Set([contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask])
        
        collisionHandlers[collision]?(contact, { _ in })
    }
    
    /** Called after an instance of SKPhysicsBody no longer made contact with the previously connected instance of SKPhysicsBody inside self's physicsWorld attribute. */
    func didEnd ( _ contact: SKPhysicsContact ) {
        let collisionHandlers : [Set<UInt32>: (SKPhysicsContact, (Player) -> Void) -> Void] = [
            [BitMaskConstant.player, BitMaskConstant.platform]: { contact, completion in
                Player.releaseContactWithPlatform(contact: contact, completion: completion)
            },
            [BitMaskConstant.player, BitMaskConstant.levelChangePlatform]: { contact, completion in
                Player.releaseContactWithPlatform(contact: contact, completion: completion)
            },
            [BitMaskConstant.player, BitMaskConstant.movingPlatform]: { contact, completion in
                let command : (Player) -> Void = { player in
                    self.currentMovingPlatform = nil
                    self.currentMovingPlatformPosition = nil
                }
                Player.releaseContactWithPlatform(contact: contact, completion: command)
            },
            [BitMaskConstant.player, BitMaskConstant.darkness]: Player.releaseContactWithDarkness
        ]
        let collision         = Set([contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask])
        
        collisionHandlers[collision]?(contact, { _ in })
    }
    
}

extension Game {
    
    func perform () {
        
    }
    
}

/* MARK: -- Extension which gives Game the ability to attend to itself. */
extension Game {
    
    /** Sets the required one-time configurations to the passed SKView */
    func setup ( _ view: SKView ) {
        view.allowsTransparency = true
        self.view!.isMultipleTouchEnabled = true
        self.backgroundColor = .clear
        self.physicsWorld.speed = 1
    }
    
    /** Renders all platforms to the scene */
    func attachElements ( fromLevelOf: String ) {
        self.generator = LevelGenerator( for: self, decipherer: [
            CSVtoNodesDecipherer( csvFileName: fromLevelOf, nodeConfigurations: GameConfig.characterMapping ),
            CSVtoMovingPlatformDecipherer(csvFileName: fromLevelOf, movingPlatformConfigurrations: GameConfig.movingPlatformMapping)
        ] )
        self.generator?.generate()
    }
    
    /** Removes all elements from the scene */
    func detachAllElements () {
        self.removeAllChildren()
    }
    
    func playAnimation () {
        findMovingPLatforms().forEach { mp in
            mp.playAction(named: ActionNamingConstant.movingPlatformMovement)
        }
    }
    
    /** After the generator has been ran, this function is called to find the attached Player node. Player object does not persist between game resets and should NOT be reattached to instance of self. */
    func findPlayerElement () throws -> Player? {
        let player : Player? = self.childNode(withName: NodeNamingConstant.player) as? Player
        if ( player == nil ) { 
            fatalError("Did not find player node after generating the level. Did you forget to write one \"PLY\" node to your file?") 
        }
        return player
    }
    
    func findMovingPLatforms () -> [MovingPlatform] {
        var movingPlatform : [MovingPlatform] = []
        self.children.forEach { mp in
            if (mp.name == NodeNamingConstant.Platform.Inert.Dynamic.moving) {
                movingPlatform.append(mp as! MovingPlatform)
            }
        }
        
        return movingPlatform
    }
    
    /** Instanciates a movement controller that controls something. Controller object deos not persist  between game reset. */
    func setupMovementController ( for target: Player ) -> MovementController {
        let controller = JoystickMovementController( controls: target )
        controller.position = CGPoint(5, 4)
        
        return controller
    }
    
    func setupOutboundIndicator () -> SKSpriteNode {
        let indicatorNode = ArrowPointingToPlayersLocationWhenOffScreen()
        indicatorNode.isHidden = true
        return indicatorNode
    }
    
    func attachDarkness () {
        let darkness = Darkness()
        darkness.position = CGPoint(5, -11)
        
        let spawnAction = SKAction.move(to: CGPoint(5, -5), duration: 1.5)
            spawnAction.timingMode = .easeInEaseOut
        let waitAction = SKAction.wait(forDuration: 2)
        let moveAction = SKAction.move(to: CGPoint(5, 11), duration: 75)
        
        let moveSequence = SKAction.sequence([spawnAction, waitAction, moveAction])
        
        darkness.run(moveSequence)
        
        addChild(darkness)
    }
    
    func slideEverythingDown () {
        let moveAction = SKAction.move(by: CGVector(dx: 0, dy: -899), duration: 5)
        for node in self.children {
            node.removeAllActions()
            node.run(moveAction)
        }
    }
    
    /// Performs a transition to the scene's elements, deloads it, renders, and animate the new level.
    func advanceToNextLevel () {
        guard ( self.state != .levelChange ) else {return}
        self.state = .levelChange
        slideEverythingDown()
        self.run(.wait(forDuration: 5)) {
            self.detachAllElements()
            self.player = nil
            self.controller = nil
            
            self.levelDidLoad()
            
            self.player = try? self.findPlayerElement()
            self.controller = self.setupMovementController(for: self.player!)
            self.attachDarkness()
            self.addChild(self.controller!)
            self.state = .playing
            self.findMovingPLatforms().forEach { mp in
                mp.playAction(named: ActionNamingConstant.movingPlatformMovement)
            }
        }
    }
    
    func levelDidLoad () {
        if ( levelTrack - LevelDesignConstant.LevelRange.autumn.upperBound == 0 ) {
            self.currentTheme = .winter
            levelTrack = 1
        }
        
        let alias = LevelDesignConstant.Naming.self
        
        var levelFilename : String = alias.prefix
        if ( self.themedLevels ) {
            levelFilename += alias.Seasonal.seasonal + currentTheme.rawValue
        } else {
            levelFilename += alias.Seasonal.nonseasonal
        }
        
            levelFilename += String(self.levelTrack)
        
        debug("\n### Loaded \(levelFilename) ###\n")
        self.attachElements(fromLevelOf: levelFilename)
        levelTrack += 1
    }
    
    /// Resets the game, and returns it to how it initially was after self's state becomes .playing
    /// 
    /// The logic is as follows:
    /// 1. It resets the state to .notYetStarted
    /// 2. It removes all elements from screen
    /// 3. It regenerates all elements anew again
    /// 4. It finds the player node from the generated level
    /// 5. It attaches the found player node
    /// 6. it attaches the controller node
    func restart () {
        self.state = .notYetStarted
        self.removeAction( forKey: ActionNamingConstant.gameSlowingDown  )
        self.speed = 1
        self.isPaused = false
        self.levelTrack = 1
        self.currentTheme = .autumn
        detachAllElements()
        levelDidLoad()
        self.player = try? findPlayerElement()
        self.controller = setupMovementController(for: self.player!)
        attachDarkness()
        self.outboundIndicator = setupOutboundIndicator()
        addChild(outboundIndicator!)
        addChild(controller!)
        self.state = .playing
        findMovingPLatforms().forEach { mp in
            mp.playAction(named: ActionNamingConstant.movingPlatformMovement)
        }
    }
    
}

/* MARK: -- Extension which lets Game track "in what state its in". */
extension Game {
    enum GameState {
        case playing,
             paused,
             notYetStarted,
             levelChange,
             finished
    }
    enum GeneratorError : Error {
        case playerIsNotAdded(String)
    }
}
