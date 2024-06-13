import SpriteKit
import Observation

@Observable class PlayerStatistic {
    
    var highestPlatform : CGPoint = CGPoint(x: 0, y: 0)
    var currentlyStandingOn : Platform? = nil {
        didSet {
            debug("player is standing on \(currentlyStandingOn)")
        }
    }
    
}

@Observable class Player : SKSpriteNode {
    
    init () {
        self.state = .idle
        self.facingDirection = .rightward
        let texture = SKTexture( imageNamed: ImageNamingConstant.Player.Idle.Right.name )
        
        super.init( texture: texture, color: .clear, size: ValueProvider.playerDimension )
        
        self.name = NodeNamingConstant.player
        self.state = .idle
        
        let physicsBody = Player.defaultPhysicsBody()
        self.physicsBody = physicsBody
    }
    
    var statistics      : PlayerStatistic = PlayerStatistic()
    var facingDirection : MovementDirection {
        didSet {
            self.state = state
        }
    }
    var state           : PlayerState {
        didSet {
            debug("Player's state: \(state)")
            previousState = oldValue

            switch state {
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
            }
        }
    }
    var previousState   : PlayerState = .idle
    var restrictions    : RestrictionGroup = RestrictionGroup()
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Player {
    
    static func calculateHeight () {
        
    }
    
    static func handlePlatformCollision ( contact: SKPhysicsContact ) {
        let nodes = UniversalNodeIdentifier.identify(
            types: [Player.self, Platform.self], 
            contact.bodyA.node!, 
            contact.bodyB.node!
        )
        if let player = nodes[0] as? Player, let platform = nodes[1] as? Platform {
            let bottomMostPointOfplayer = player.position.y   - player.size.height   / 2
            let topMostPointOfPlatform  = platform.position.y + platform.size.height / 2
            
            if ( bottomMostPointOfplayer >= topMostPointOfPlatform - 0.8 ) {
                player.state = .idle
                
                player.statistics.currentlyStandingOn = platform
                
                if ( player.statistics.highestPlatform.y < platform.position.y ) {
                    player.statistics.highestPlatform = platform.position
                }
                
                calculateHeight()
                
                player.restrictions.list.removeValue(forKey: RestrictionConstant.Player.jump)
            } 
        }
    }
    
    static func releasePlatformCollision ( contact: SKPhysicsContact ) {
        //
    }
    
    static func handleDarknessCollision ( contact: SKPhysicsContact ) {
        let nodes = UniversalNodeIdentifier.identify(
            types: [Player.self, Darkness.self], 
            contact.bodyA.node!, 
            contact.bodyB.node!
        )
        if let player = nodes[0] as? Player, let platform = nodes[1] as? Darkness {
            // die
        }
    }
    
}

extension Player {
    
    static func defaultPhysicsBody ( ) -> SKPhysicsBody {
        let pb = SKPhysicsBody( rectangleOf: ValueProvider.playerPhysicsBodyDimension, center: CGPoint(x: 0, y: -5) )
        
            pb.isDynamic          = GameConfig.playerIsDynamic
            pb.mass               = GameConfig.playerMass
            pb.linearDamping      = GameConfig.playerLinearDamping
            pb.friction           = GameConfig.playerFriction
            pb.allowsRotation     = GameConfig.playerRotates
        
            pb.categoryBitMask    = BitMaskConstant.player
            pb.contactTestBitMask = BitMaskConstant.platform
        
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
             climbing
    }
    
}