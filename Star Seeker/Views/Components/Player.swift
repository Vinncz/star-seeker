import SpriteKit
import Observation

struct PlayerRestriction {
    
}

@Observable class Player : SKSpriteNode {
    
    var isMoving      : Bool {
        let movingStates : [PlayerState] = [.movingLeft, .movingRight, .jumpingLeft, .jumpingRight]
        return movingStates.contains { s in
            s == state
        }
    }
    var state         : PlayerState {
        didSet {
            debug("Player's state: \(state)")
            previousState = oldValue

            switch state {
                case .idleLeft:
                    self.removeAction( forKey: ActionNamingConstant.moving   )
                    self.removeAction( forKey: ActionNamingConstant.jumping  )
                    self.removeAction( forKey: ActionNamingConstant.climbing )
                    if ( self.action ( forKey: ActionNamingConstant.idle     ) == nil ) {
                        let idleLeftTextures : [SKTexture] = (0...30).map { SKTexture(imageNamed: ImageNamingConstant.Player.Idle.Left.name + String($0)) }
                        let idleLeftAction   = SKAction.animate(with: idleLeftTextures, timePerFrame: 0.034)
                        
                        self.run(SKAction.repeatForever(idleLeftAction), withKey: ActionNamingConstant.idle)
                    }
                    break
                    
                case .idleRight:
                    self.removeAction( forKey: ActionNamingConstant.moving   )
                    self.removeAction( forKey: ActionNamingConstant.jumping  )
                    self.removeAction( forKey: ActionNamingConstant.climbing )
                    if ( self.action ( forKey: ActionNamingConstant.idle     ) == nil ) {
                        let idleRightTextures : [SKTexture] = (0...30).map { SKTexture(imageNamed: ImageNamingConstant.Player.Idle.Right.name + String($0)) }
                        let idleRightAction   = SKAction.animate(with: idleRightTextures, timePerFrame: 0.034)
                        
                        self.run(SKAction.repeatForever(idleRightAction), withKey: ActionNamingConstant.idle)
                    }
                    break
                    
                case .movingLeft:
                    self.removeAction( forKey: ActionNamingConstant.idle    )
                    self.removeAction( forKey: ActionNamingConstant.jumping )
                    if ( self.action ( forKey: ActionNamingConstant.moving  ) == nil ) {
                        let movingLeftTextures : [SKTexture] = (0...19).map { SKTexture(imageNamed: ImageNamingConstant.Player.Moving.Left.name + String($0)) }
                        let movingLeftAction   = SKAction.animate(with: movingLeftTextures, timePerFrame: 0.05)
                        
                        self.run(SKAction.repeatForever(movingLeftAction), withKey: ActionNamingConstant.moving)
                    }
                    break
                    
                case .movingRight:
                    self.removeAction( forKey: ActionNamingConstant.idle    )
                    self.removeAction( forKey: ActionNamingConstant.jumping )
                    if ( self.action ( forKey: ActionNamingConstant.moving  ) == nil ) {
                        let movingRightTextures : [SKTexture] = (0...19).map { SKTexture(imageNamed: ImageNamingConstant.Player.Moving.Right.name + String($0)) }
                        let movingRightAction = SKAction.animate(with: movingRightTextures, timePerFrame: 0.05)
                        
                        self.run(SKAction.repeatForever(movingRightAction), withKey: ActionNamingConstant.moving)
                    }
                    break
                    
                case .jumpingLeft:
                    self.removeAction( forKey: ActionNamingConstant.idle     )
                    self.removeAction( forKey: ActionNamingConstant.moving   )
                    self.removeAction( forKey: ActionNamingConstant.jumping  )
                    self.removeAction( forKey: ActionNamingConstant.climbing )
                    if ( self.action ( forKey: ActionNamingConstant.jumping  ) == nil ) {
                        let jumpingLeftTextures : [SKTexture] = (0...19).map { SKTexture( imageNamed: ImageNamingConstant.Player.Jumping.Left.name + String($0) ) }
                        let jumpingLeftAction   = SKAction.animate( with: jumpingLeftTextures, timePerFrame: 0.03 )

                        self.run( SKAction.repeatForever(jumpingLeftAction), withKey: ActionNamingConstant.jumping )
                    }
                    break
                    
                case .jumpingRight:
                    self.removeAction( forKey: ActionNamingConstant.idle     )
                    self.removeAction( forKey: ActionNamingConstant.moving   )
                    self.removeAction( forKey: ActionNamingConstant.jumping  )
                    self.removeAction( forKey: ActionNamingConstant.climbing )
                    if ( self.action ( forKey: ActionNamingConstant.jumping  ) == nil ) {
                        let jumpingRightTextures : [SKTexture] = (0...19).map { SKTexture( imageNamed: ImageNamingConstant.Player.Jumping.Right.name + String($0) ) }
                        let jumpingRightAction   = SKAction.animate( with: jumpingRightTextures, timePerFrame: 0.03 )

                        self.run( SKAction.repeatForever(jumpingRightAction), withKey: ActionNamingConstant.jumping )
                    }
                    break
                    
                case .climbing:
                    self.removeAction( forKey: ActionNamingConstant.idle     )
                    self.removeAction( forKey: ActionNamingConstant.moving   )
                    self.removeAction( forKey: ActionNamingConstant.jumping  )
                    if ( self.action ( forKey: ActionNamingConstant.climbing ) == nil ) {
                        let climbingTextures : [SKTexture] = (0...8).map { SKTexture( imageNamed: ImageNamingConstant.Player.Climbing.name + String($0) ) }
                        let climbingAction   = SKAction.animate( with: climbingTextures, timePerFrame: 0.05 )
                        
                        self.run( SKAction.repeatForever(climbingAction), withKey: ActionNamingConstant.climbing )
                    }
                    break
            }
        }
    }
    var previousState : PlayerState = .idleRight
    var restrictions  : [PlayerRestriction]
    
    init () {
        self.state = .idleRight
        self.restrictions = []
        let texture = SKTexture( imageNamed: ImageNamingConstant.Player.Idle.Right.name )
        
        super.init( texture: texture, color: .clear, size: ValueProvider.playerDimension )
        
        self.name = NodeNamingConstant.player
        self.state = .idleRight
        
        let physicsBody = Player.defaultPhysicsBody()
        self.physicsBody = physicsBody
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Player {
    
    static func defaultPhysicsBody ( ) -> SKPhysicsBody {
        let pb = SKPhysicsBody( rectangleOf: ValueProvider.playerDimension )
            pb.isDynamic          = GameConfig.playerIsDynamic
            pb.mass               = GameConfig.playerMass
            pb.linearDamping      = GameConfig.playerLinearDamping
            pb.friction           = GameConfig.playerFriction
            pb.allowsRotation     = GameConfig.playerRotates
        
            pb.categoryBitMask    = NodeCategory.player.bitMask
            pb.contactTestBitMask = NodeCategory.platform.bitMask
        
            pb.usesPreciseCollisionDetection = true
        
        return pb
    } 
    
}

extension Player {
    
    enum PlayerState {
        case idleLeft,
             idleRight,
             movingLeft,
             movingRight,
             jumpingLeft,
             jumpingRight,
             climbing
    }
    
}
