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
        self.state = .notYetStarted
        
        super.init(size: size)
        
        self.name      = NodeNamingConstant.game
        self.scaleMode = .resizeFill
        self.physicsWorld.contactDelegate = self
    }
    
    /** Called after an instace of Game is shown at some SKView instance. */
    override func didMove ( to view: SKView ) {
        ValueProvider.screenDimension = UIScreen.main.bounds.size
        prepareForPerformance()
        
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
                    let slowDownAction = SKAction.customAction(withDuration: 2) { _, elapsedTime in
                        let progress = elapsedTime / 2
                        self.speed = 1 - progress
                    }
                    self.run(slowDownAction, withKey: ActionNamingConstant.gameSlowingDown)
                default:
                    break
            }
            
            print("Game state was updated to: \(state)")
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
    var darkness      : Darkness?
    var darknessOverlay : SKSpriteNode?
    var statistics    : GameStatistic = GameStatistic()
    
    var levelTrack    : Int  = 1
    var currentTheme  : Season = .spring
    var themedLevels  : Bool = true
    
    var outboundIndicator: SKSpriteNode?
    var currentMovingPlatform: SKSpriteNode?
    var currentMovingPlatformPosition: CGPoint?
    
    var levelDesignFileName : String = "leveldesign.seasonal.spring.1"
    var themeSequence       : [Season] = [.autumn, .winter, .spring, .summer]

    /* Inherited from SKScene. Refrain from altering the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/* MARK: -- Extension which gives Game the ability to recieve and respond to contact between two physics bodies within its physicsWorld. */
extension Game {
    
    /// Called everytime the frame updates
    override func update ( _ currentTime: TimeInterval ) {
        updatePlayerPositionIfTheyAreOnMovingPlatform()
        updateOutboundIndicator()
//        applyVignetteIfDarknessComesTooClose()
    }
    
    /// Called after an instace of SKPhysicsBody collided with another instance of SKPhysicsBody inside self's physicsWorld attribute. 
    /// Their contactBitMask attribute must match the bitwise operation "OR" in order for this method to be called.
    func didBegin ( _ contact: SKPhysicsContact ) {
        let collisionHandlers : [Set<UInt32>: (SKPhysicsContact, @escaping (Player) -> Void) -> Void] = [
            [BitMaskConstant.player, BitMaskConstant.platform]: { contact, completion in
                Player.intoContactWithPlatform(contact: contact, completion: completion)
            },
            [BitMaskConstant.player, BitMaskConstant.levelChangePlatform]: { contact, completion in
                let command : ( Player ) -> Void = { player in
                    if ( self.state != .levelChange ) { 
                        self.statistics.accumulativeScore += (player.statistics!.currentHeight.y) - (player.statistics!.spawnPosition.y)
                        self.transitionToNextScene()
                    }
                    player.statistics!.currentHeight.y = player.statistics!.spawnPosition.y
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
                    if let _ = nodes[0] as? Player, let platform = nodes[1] as? MovingPlatform {
                        if ( self.currentMovingPlatform == nil ) {
                            self.currentMovingPlatform = platform
                        } 
                    }
                }
                Player.intoContactWithPlatform(contact: contact, completion: command)
            },
            [BitMaskConstant.player, BitMaskConstant.collapsiblePlatform]: { contact, completion in
                let command : ( Player ) -> Void = { player in
                    let nodes = UniversalNodeIdentifier.identify (
                        checks: [
                            { $0 as? Player },
                            { $0 as? CollapsiblePlatform },
                        ], 
                        contact.bodyA.node!, 
                        contact.bodyB.node!
                    )
                    if let _ = nodes[0] as? Player, let platform = nodes[1] as? CollapsiblePlatform {
                        platform.playAction(named: ActionNamingConstant.collapseOfCollapsiblePlatform) { 
                            platform.actionPool.removeValue(forKey: ActionNamingConstant.collapseOfCollapsiblePlatform)
                            platform.removeFromParent()
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
    
    /// Called after an instance of SKPhysicsBody no longer made contact with the previously connected instance of SKPhysicsBody inside self's physicsWorld attribute.
    func didEnd ( _ contact: SKPhysicsContact ) {
        let collisionHandlers : [Set<UInt32>: (SKPhysicsContact, @escaping (Player) -> Void) -> Void] = [
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
            [BitMaskConstant.player, BitMaskConstant.collapsiblePlatform]: { contact, completion in
                Player.releaseContactWithPlatform(contact: contact, completion: completion)
            },
            [BitMaskConstant.player, BitMaskConstant.darkness]: Player.releaseContactWithDarkness
        ]
        let collision         = Set([contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask])
        
        collisionHandlers[collision]?(contact, { _ in })
    }
    
}


/* MARK: -- Extension which lets Game to attend to itself */
extension Game {
    
    
    /// Restarts the game (cold-start)
    final func restart () {
        self.removeAllActions()
        self.haltPerformance()
        self.performersToRest()
        self.prepareForNextPerformance()
        self.statistics.reset()
        
        self.levelDesignFileName = "leveldesign.seasonal.spring.1"
        self.currentTheme = .spring
        self.levelTrack = 1
        self.speed = 1
        
        self.prepareForPerformance()
        self.perform()
    }
    
    
    /// Prepares self for gameplay activity.
    /// 
    /// Preparations include:
    /// 1. Setting up one-time stage attributes
    /// 2. Instanciating SKNodes (performers) which later will be attached
    /// 3. Assigning SKAction to performers
    /// 4. Miscl. preparations
    final func prepareForPerformance () {
        debug("executing: \(#function)")
        prepareStage()
        
        let performersPreparation = preparePerformers()
                   self.generator = performersPreparation.performersManager
               rehearsePerformers ( performersPreparation.performers )
        
        prepareExtras()
        
    }
    
    
    /// Performs the gameplay activity.
    /// 
    /// 1. Performers are let onto stage.
    /// 2. Performers are given cue to begin their SKActions.
    /// 3. Miscl. actions
    final func perform () {
        debug("executing: \(#function)")
        performersToStage()
        performersMayPerform()
        performExtras()
    }
    
    
    /// Cleanse the scene to start anew on a clean slate.
    /// 
    /// This method:
    /// 1. Animates all performers to leave the stage, elegantly
    /// 2. Removes the performers after they're out of view
    /// 3. Resets the applicable statistics. Statistics which attach itself to the scene's lifecycle will not be reset. However, if the scene were to be destroyed, all statistics will also be reset.
    final func cleanup () {
        debug("executing: \(#function)")
        haltPerformance()
        performersToLeaveTheStage()
        self.run(.wait(forDuration: 2)) {
            self.performersToRest()
            self.prepareForNextPerformance()
        }
    }
    
    
    /// Signals every scene-observers that: the scene is currently underway in changing the played level with a new one. This function alone ___won't___ change the currently active level.
    /// 
    /// To commit to a level change, ``proceedWithGeneratingNewLevel()`` needs to be called to actually populate the level with new level design.
    /// 
    /// This function does not shut down the scene. To shut down a scene, like you would after the player has exited the game, refer to ``endPerformance()``.
    final func transitionToNextScene () {
        debug("executing: \(#function)")
        guard ( self.state != .levelChange && self.state != .awaitingTransitionFinish ) else {return}
        
        self.state = .levelChange
        cleanup()
//        proceedWithGeneratingNewLevel()
    }

    
    /// Executed in tandem with ``transitionToNextScene()``. This method awaits execution after the tower has done transitioning, and once it is called, it populate the game with new level design.
    /// 
    /// This method:
    /// 1. Changes the level being played
    /// 2. Updates the season, if level design does not have any more levels matching ``currentTheme`` , 
    /// 3. Calls
    func proceedWithGeneratingNewLevel () {
        guard ( self.state == .awaitingTransitionFinish ) else { return }
        
        let levelBound : ClosedRange<Int>
        switch ( currentTheme ) {
            case .autumn:
                levelBound = LevelDesignConstant.LevelRange.autumn
            case .winter:
                levelBound = LevelDesignConstant.LevelRange.winter
            case .spring:
                levelBound = LevelDesignConstant.LevelRange.spring
            case .summer:
                levelBound = LevelDesignConstant.LevelRange.summer
            default:
                levelBound = 0...0
        }
        
        if ( self.levelTrack % levelBound.upperBound == 0 ) {
            if let currentIndex = themeSequence.firstIndex(of: currentTheme) {
                let nextIndex = (currentIndex + 1) % themeSequence.count
                self.currentTheme = themeSequence[nextIndex]
            }
            self.levelTrack = 1
        }
        
        self.levelDesignFileName = LevelDesignConstant.Naming.prefix 
        if ( themedLevels ) {
            self.levelDesignFileName += LevelDesignConstant.Naming.Seasonal.seasonal + self.currentTheme.rawValue 
        } else {
            self.levelDesignFileName += LevelDesignConstant.Naming.Seasonal.nonseasonal
        }
        self.levelTrack += 1
        self.levelDesignFileName += "\(self.levelTrack)"
        
        self.prepareForPerformance()
        self.perform()
    }
    
    
    /// Shuts down a scene, reverting it back to how it was, when its state is ``.notYetStarted``.
    final func endPerformance () {
        cleanup()
        resetEverything()
    }
    
    
    /// Resets every statistics, be it marked specifically to persist between game resets or not.
    /// 
    /// If the scene were to be destroyed, all statistics will also be reset regardless.
    func resetEverything () {
        self.state         = .notYetStarted
        physicsWorld.speed = 1
        isPaused           = false
        statistics.reset()
    }
        
}

/* MARK: -- Extension which supports Game's ``prepareForPerformance()`` method */
extension Game {
    
    /// Sets up one-time stage attributes.
    func prepareStage () {
        debug("executing: \(#function)")
        view?.allowsTransparency     = true
        view?.isMultipleTouchEnabled = true
        backgroundColor              = .clear
        physicsWorld.speed           = 1
        self.state                   = .notYetStarted
        self.isPaused                = false
    }
    
    
    /// Creates instances of SKNodes, through the means of setting up one ``LevelGenerator``, and getting the generated nodes from there.
    /// 
    /// "Generated" doesn't mean the SKNodes are put to scene -- LevelGenerator will not populate the scene, until ``performersToStage()`` is called.
    func preparePerformers () -> ( performersManager: LevelGenerator, performers: [SKSpriteNode]) {
        debug("executing: \(#function)")
        debug("Opening up level design: \(self.levelDesignFileName)")
        let gene = LevelGenerator ( 
            for        : self, 
            decipherer : [
                CSVtoNodesDecipherer          ( csvFileName: self.levelDesignFileName, nodeConfigurations           : GameConfig.characterMapping     ),
                CSVtoMovingPlatformDecipherer ( csvFileName: self.levelDesignFileName, movingPlatformConfigurrations: GameConfig.movingPlatformMapping)
            ]
        )
                
        return (gene, gene.getValuedNodes())
    }
    
    
    /// Attaches additional SKActions to every performers's actionPool.
    /// 
    /// These actions will not execute until ``performersMayPerform()`` is called.
    func rehearsePerformers ( _ performers: [SKNode] ) {
        debug("executing: \(#function)")
        
        performers.forEach { p in
            let additionalActions : [String : SKAction] = [
                ActionNamingConstant.spawnIn : SKAction.sequence([
                    SKAction.group([
                        SKAction.fadeOut(withDuration: 0.001),
                        SKAction.moveBy(x: 0, y: -12, duration: 0.001),
                        SKAction.scale(to: 0.5, duration: 0.001)
                    ]),
                    SKAction.group([
                        SKAction.fadeIn(withDuration: Double.random(in: 0...1.5)),
                        SKAction.moveBy(x: 0, y: 12, duration: Double.random(in: 0...0.75)),
                        SKAction.scale(to: 1, duration: Double.random(in: 0...0.75))
                    ])
                ])
            ]
            
            /* Overrides any old value with the ones in `additionalActions` */
            p.actionPool.merge(additionalActions) { _, new in new }
        }
    }
    
    
    /// Performs any last bit of preparation, before self is managed by ``perform()``.
    func prepareExtras () {
        debug("executing: \(#function)")
    }
    
}


/* MARK: -- Extension which supports Game's ``perform()`` method */
extension Game {
    
    /// Populates the scene with SKNodes which were generated by ``LevelGenerator``.
    /// 
    /// This method does not make ``LevelGenerator`` to generate new SKNodes. To make it to do so, refer to ``preparePerformers()``.
    func performersToStage () {
        debug("executing: \(#function)")
        self.generator?.generate()
        
        self.player            = findPlayerElement()
        self.controller        = setupMovementController(for: player!)
        self.outboundIndicator = setupOutboundIndicator()
        self.darknessOverlay   = prepareDarknessOverlay()
        self.darkness          = prepareDarkness()
        
        addChild(darkness!)
        addChild(darknessOverlay!)
        addChild(outboundIndicator!)
        addChild(controller!)
    }
    
    
    /// Cue the performers to begin performing their SKActions.
    func performersMayPerform () {
        debug("executing: \(#function)")
        self.generator?.getNodes().forEach({ decipherers2DNodes in
            decipherers2DNodes.forEach { decipherersRow in
                decipherersRow.forEach { decipherersColumn in
                    decipherersColumn?.playAction(named: ActionNamingConstant.spawnIn)
                    decipherersColumn?.playAction(named: ActionNamingConstant.movingPlatformMovement)
                }
            }
        })
        self.state = .playing
    }
    
    /// Extra
    func performExtras () {
        debug("executing: \(#function)")
        self.state = .playing
        self.isPaused = false
        self.physicsWorld.speed = 1
        self.run(.wait(forDuration: 0.75)) {
            let p = self.findPlayerElement()
            p.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 15))
            p.state = .idle
        }
    }
    
}


/* MARK: -- Extension which supports Game's ``cleanup()`` method */
extension Game {
    
    
    func haltPerformance () {
        debug("executing: \(#function)")
        for node in self.children {
            node.removeAllActions()
        }
    }
    
    func performersToLeaveTheStage () {
        debug("executing: \(#function)")
        let moveAction = SKAction.move(by: CGVector(dx: 0, dy: -899), duration: 2)
        for node in self.children {
            node.run(moveAction)
        }
    }
    
    func performersToRest () {
        debug("executing: \(#function)")
        self.removeAllChildren()
    }
    
    /// Resets variables that are bound to a 
    func prepareForNextPerformance () {
        debug("executing: \(#function)")
        self.outboundIndicator = nil
        self.player = nil
        self.controller = nil
    }
    
}


/* MARK: -- Extension which enables Game to examine itself */
extension Game {
    
    /// Searches self structure tree for a single SKNode with the signature of ``Player``. 
    /// 
    /// Since player object does not persist between game resets and is ___not___ to be reattached to instance of self, one is generated everytime the scene is populated.
    /// 
    /// Should there be no Player not to be found, the game will not load -- since the winning condition will never be met.
    func findPlayerElement () -> Player {
        let player : Player? = self.childNode(withName: NodeNamingConstant.player) as? Player
        if ( player == nil ) { 
            fatalError("Did not find player node after generating the level. Did you forget to write one \"PLY\" node to your file?") 
        }
        return player!
    }
    
    
    /// Searches self structure tree for SKNodes with the signature of ``MovingPlatform``. 
    /// 
    /// Since player object does not persist between game resets and is ___not___ to be reattached to instance of self, one is generated everytime the scene is populated.
    /// 
    /// Should there be no Player not to be found, the game will not load -- since the winning condition will never be met.
    func findMovingPLatforms () -> [MovingPlatform] {
        var movingPlatform : [MovingPlatform] = []
        self.children.forEach { mp in
            if (mp.physicsBody?.categoryBitMask == BitMaskConstant.movingPlatform) {
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
    
    func prepareDarkness () -> Darkness {
        let darkness = Darkness()
        darkness.position = CGPoint(5, -11)
        
        let spawnAction = SKAction.move(to: CGPoint(5, -5), duration: 1.5)
            spawnAction.timingMode = .easeInEaseOut
        let waitAction = SKAction.wait(forDuration: 2)
        let moveAction = SKAction.move(to: CGPoint(5, 11), duration: 75)
        
        let moveSequence = SKAction.sequence([spawnAction, waitAction, moveAction])
        
        darkness.run(moveSequence)
        
        return darkness
    }
}


/* MARK: -- Extension which gives Game the ability to attend to itself. */
extension Game {
    
    func updatePlayerPositionIfTheyAreOnMovingPlatform () {
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
    }
    
    func updateOutboundIndicator () {
        guard let playerPosition = self.player?.position, let outboundIndicatorNode = self.outboundIndicator else {
            return
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
    
    func applyVignetteIfDarknessComesTooClose () {
        guard let player = self.player, let darkness = self.darkness else { return }
        let distance = abs(player.position.y - darkness.position.y)
        print("darkness distance: \(distance) -- darkness height: \(self.darknessOverlay?.size.height ?? 0)")
        if ( distance <= 50 + (self.darknessOverlay?.size.height ?? 0) / 2 ) {
            self.darknessOverlay?.alpha = 1
            
        } else if ( distance <= 75 + (self.darknessOverlay?.size.height ?? 0) / 2 ) {
            self.darknessOverlay?.alpha = 0.75
            
        } else if ( distance <= 100 + (self.darknessOverlay?.size.height ?? 0) / 2 ) {
            self.darknessOverlay?.alpha = 0.5
            
        } else {
            self.darknessOverlay?.alpha = 0
        }
    }
    
    func prepareDarknessOverlay () -> SKSpriteNode {
        let overlay = SKSpriteNode(texture: SKTexture(imageNamed: "darknes_vignette"), color: .clear, size: ValueProvider.screenDimension)
            overlay.position = CGPoint(x: ValueProvider.screenDimension.width / 2, y: ValueProvider.screenDimension.height / 2)
            overlay.alpha = 0
        return overlay
    }
    
}


/* MARK: -- Extension which lets Game track "in what state its in". */
extension Game {
    enum GameState {
        case playing,
             paused,
             notYetStarted,
             levelChange,
             awaitingTransitionFinish,
             finished
    }
    enum GeneratorError : Error {
        case playerIsNotAdded(String)
    }
}

@Observable class GameStatistic {
    
    var accumulativeScore : Double = 0 
    
    func reset () {
        self.accumulativeScore = 0
    }
    
}
