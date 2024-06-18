import SpriteKit
import Observation

@Observable class Player : SKSpriteNode {
    
    init () {
        self.state = .idle
        self.facingDirection = .rightward
        let texture = SKTexture( imageNamed: ImageNamingConstant.Player.Idle.Right.name )
        
        super.init( texture: texture, color: .clear, size: ValueProvider.playerDimension )
        
        self.statistics = PlayerStatistic(for: self)
        self.name = NodeNamingConstant.player
        self.state = .idle
        
        let physicsBody = Player.defaultPhysicsBody()
        self.physicsBody = physicsBody
    }
    
    var statistics      : PlayerStatistic?
    var facingDirection : MovementDirection {
        didSet {
            /* ABSTRACT: Different direction sometimes require new textures to be drawn */
            self.state = state
        }
    }
    var state           : PlayerState {
        didSet {
            /* ABSTRACT: Different state requires different textures */
            debug("Player's state: \(state)")
            previousState = oldValue
            updateSelfTextures()
        }
    }
    var previousState   : PlayerState = .idle
    var restrictions    : RestrictionGroup = RestrictionGroup()
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/* MARK: -- Extension which gives Player the ability to handle collision */
extension Player {
    
    /// Called when an instance of player collided with an instance of platform.
    static func intoContactWithPlatform ( contact: SKPhysicsContact ) {
        let nodes = UniversalNodeIdentifier.identify (
            checks: [
                { $0 as? Player },
                { $0 as? Platform },
            ], 
            contact.bodyA.node!, 
            contact.bodyB.node!
        )
        if let player = nodes[0] as? Player, let platform = nodes[1] as? Platform {
            debug("Player collided with \(platform.position) platform -- with player's feet position of \(player.position.y   - (player.size.height   / 2)) and platform's top at \(platform.position.y + (platform.size.height / 2))")
            
            let expandedFrame = platform.frame.insetBy(dx: -1, dy: -1)
            let contactPoint = contact.contactPoint
            if ( expandedFrame.contains(contactPoint) ) {
                player.statistics!.currentlyStandingOn.insert(platform)
                
                if ( player.statistics!.highestPlatform.y < platform.position.y ) {
                    player.statistics!.highestPlatform = platform.position
                }                                
            } 
        }
    }
    
    /// Called when an instance of player is no longer in contact with an instance of platform.
    static func releaseContactWithPlatform ( contact: SKPhysicsContact ) {
        let nodes = UniversalNodeIdentifier.identify (
            checks: [
                { $0 as? Player },
                { $0 as? Platform },
            ], 
            contact.bodyA.node!, 
            contact.bodyB.node!
        )
        if let player = nodes[0] as? Player, let platform = nodes[1] as? Platform {
            debug("Player did release from \(platform.position)")
            player.statistics!.currentlyStandingOn.remove(platform)
        }
    }
    
    /// Called when an instace of player collided with an instace of darkness.
    static func intoContactWithDarkness ( contact: SKPhysicsContact ) {
        let nodes = UniversalNodeIdentifier.identify (
            checks: [
                { $0 as? Player },
                { $0 as? Darkness },
            ], 
            contact.bodyA.node!, 
            contact.bodyB.node!
        )
        if let player = nodes[0] as? Player, let darkness = nodes[1] as? Darkness {
            debug("Player collided with darkness object at \(darkness.position) -- with player's feet position of \(player.position.y - (player.size.height / 2)) and darkness' top at \(darkness.position.y + (darkness.size.height / 2))")
            player.state = .dying
        }
    }
    
    /// This method is only called when an instace of player collided with an instace of darkness.
    static func releaseContactWithDarkness ( contact: SKPhysicsContact ) {
        let nodes = UniversalNodeIdentifier.identify(
            checks: [
                { $0 as? Player },
                { $0 as? Darkness },
            ], 
            contact.bodyA.node!, 
            contact.bodyB.node!
        )
        if let player = nodes[0] as? Player, let darkness = nodes[1] as? Darkness {
            debug("Player did release from \(darkness.position) darkness. Player is at \(player.position)")
            print("How did you ... ?!")
        }
    }
}

extension Player {
    
    /** Instanciates a physicsBody that is fitting for a Player object, with the default preset already configured into it.  */
    static func defaultPhysicsBody ( ) -> SKPhysicsBody {
        let pb = SKPhysicsBody( rectangleOf: ValueProvider.playerPhysicsBodyDimension, center: CGPoint(x: 0, y: -5) )
        
            pb.isDynamic          = GameConfig.playerIsDynamic
            pb.mass               = GameConfig.playerMass
            pb.linearDamping      = GameConfig.playerLinearDamping
            pb.friction           = GameConfig.playerFriction
            pb.allowsRotation     = GameConfig.playerRotates
            pb.restitution        = 0
        
            pb.categoryBitMask    = BitMaskConstant.player
            pb.contactTestBitMask = BitMaskConstant.platform | BitMaskConstant.darkness
        
            pb.usesPreciseCollisionDetection = true
        
        return pb
    } 
    
}

extension Player {
    enum PlayerState {
        case idle,
             moving,
             squating,
             jumping,
             climbing,
             dying
    }
    
    func updateSelfTextures () {
        switch ( self.state ) {
            case .idle:
                self.removeAction( forKey: ActionNamingConstant.moving   )
                self.removeAction( forKey: ActionNamingConstant.jumping  )
                self.removeAction( forKey: ActionNamingConstant.climbing )
                if ( self.action ( forKey: ActionNamingConstant.idle     ) == nil ) {
                    let textureName  : String = self.facingDirection == .leftward ? ImageNamingConstant.Player.Idle.Left.name : ImageNamingConstant.Player.Idle.Right.name
                    let idleTextures : [SKTexture] = (0...30).map { SKTexture( imageNamed: textureName + String($0) ) }
                    let idleAction   = SKAction.animate(with: idleTextures, timePerFrame: 0.034)
                    
                    self.run(SKAction.repeatForever(idleAction), withKey: ActionNamingConstant.idle)
                }
                break
                
            case .moving:
                self.removeAction( forKey: ActionNamingConstant.idle    )
                self.removeAction( forKey: ActionNamingConstant.jumping )
                if ( self.action ( forKey: ActionNamingConstant.moving  ) == nil ) {
                    let textureName    : String = self.facingDirection == .leftward ? ImageNamingConstant.Player.Moving.Left.name : ImageNamingConstant.Player.Moving.Right.name
                    let movingTextures : [SKTexture] = (0...19).map { SKTexture( imageNamed: textureName + String($0) ) }
                    let movingAction   = SKAction.animate(with: movingTextures, timePerFrame: 0.05)
                    
                    self.run(SKAction.repeatForever(movingAction), withKey: ActionNamingConstant.moving)
                }
                break
                
            case .squating:
                self.removeAction( forKey: ActionNamingConstant.idle     )
                self.removeAction( forKey: ActionNamingConstant.moving   )
                self.removeAction( forKey: ActionNamingConstant.jumping  )
                self.removeAction( forKey: ActionNamingConstant.climbing )
                if ( self.action ( forKey: ActionNamingConstant.squating ) == nil ) {
                    let textureName      : String = ImageNamingConstant.Player.Squating.name
                    let squatingTextures : [SKTexture] = (0...10).map { SKTexture( imageNamed: textureName + String($0) ) }
                    let squatingAction   = SKAction.animate(with: squatingTextures, timePerFrame: 0.05)
                    
                    self.run(SKAction.repeatForever(squatingAction), withKey: ActionNamingConstant.squating)
                }
                break
                
            case .jumping:
                self.removeAction( forKey: ActionNamingConstant.idle     )
                self.removeAction( forKey: ActionNamingConstant.moving   )
                self.removeAction( forKey: ActionNamingConstant.jumping  )
                self.removeAction( forKey: ActionNamingConstant.climbing )
                self.removeAction( forKey: ActionNamingConstant.squating )
                if ( self.action ( forKey: ActionNamingConstant.jumping  ) == nil ) {
                    let textureName     : String = self.facingDirection == .leftward ? ImageNamingConstant.Player.Jumping.Left.name : ImageNamingConstant.Player.Jumping.Right.name
                    let jumpingTextures : [SKTexture] = (0...19).map { SKTexture( imageNamed: textureName + String($0) ) }
                    let jumpingAction   = SKAction.animate( with: jumpingTextures, timePerFrame: 0.03 )

                    self.run( SKAction.repeatForever(jumpingAction), withKey: ActionNamingConstant.jumping )
                }
                break
                
            case .climbing:
                self.removeAction( forKey: ActionNamingConstant.idle     )
                self.removeAction( forKey: ActionNamingConstant.moving   )
                self.removeAction( forKey: ActionNamingConstant.jumping  )
                if ( self.action ( forKey: ActionNamingConstant.climbing ) == nil ) {
                    let textureName      : String = ImageNamingConstant.Player.Climbing.name
                    let climbingTextures : [SKTexture] = (0...8).map { SKTexture( imageNamed: textureName + String($0) ) }
                    let climbingAction   = SKAction.animate( with: climbingTextures, timePerFrame: 0.05 )
                    
                    self.run( SKAction.repeatForever(climbingAction), withKey: ActionNamingConstant.climbing )
                }
                break
                
            case .dying:
                self.removeAction( forKey: ActionNamingConstant.idle       )
                self.removeAction( forKey: ActionNamingConstant.moving     )
                self.removeAction( forKey: ActionNamingConstant.jumping    )
                self.removeAction( forKey: ActionNamingConstant.climbing   )
                self.removeAction( forKey: ActionNamingConstant.squating   )
                if ( self.action ( forKey: ActionNamingConstant.dyingBlink ) == nil && self.action ( forKey: ActionNamingConstant.dyingRotation ) == nil ) {
                    self.color = .red
                    let tintAction = SKAction.sequence([
                        SKAction.run { self.colorBlendFactor = 0.5 },
                        SKAction.wait(forDuration: 0.5),
                        SKAction.run { self.colorBlendFactor = 0 },
                        SKAction.wait(forDuration: 1.0),
                    ])
                    let rotateAction = SKAction.sequence([
                        SKAction.run { self.zRotation += .pi / 16 },
                        SKAction.wait(forDuration: 0.05),
                    ])
                    self.run(SKAction.repeatForever(tintAction),   withKey: ActionNamingConstant.dyingBlink)
                    self.run(SKAction.repeatForever(rotateAction), withKey: ActionNamingConstant.dyingRotation)
                }
                break
        }
    }
}

@Observable class PlayerStatistic {
    
    let owner : Player
    init ( for player: Player ) {
        self.owner = player
    }
    
    var highestPlatform : CGPoint = CGPoint(x: 0, y: 0)
    var currentHeight   : CGPoint = CGPoint(x: 0, y: 0)
    var currentlyStandingOn : Set<Platform> = [] {
        didSet {
            debug("player is standing on:")
            currentlyStandingOn.forEach {
                debug("    \($0.name), \($0.position)")
            }
            debug("")
            
            if ( currentlyStandingOn.first == nil ) {
                self.currentHeight = oldValue.first?.position ?? CGPoint(x: 0, y: 0)
            } else {
                self.currentHeight = currentlyStandingOn.first?.position ?? CGPoint(x: 0, y: 0)
            }
            
            if ( currentlyStandingOn.isEmpty ) {
                owner.state = .jumping
                owner.restrictions.list[RestrictionConstant.Player.jump] = PlayerRestriction( comparer: {
                    self.owner.statistics!.currentlyStandingOn == nil 
                } )
            } else {
                owner.state = .idle
                owner.restrictions.list.removeValue(forKey: RestrictionConstant.Player.jump)
            }
        }
    }
    
}
