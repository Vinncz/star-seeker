import SpriteKit
import Observation

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
                    self.removeAction(forKey: ActionNamingConstant.moving)
                    if ( self.action(forKey: ActionNamingConstant.idle) == nil ) {
                        let idleLeftTextures : [SKTexture] = (0...30).map { SKTexture(imageNamed: ImageNamingConstant.Player.Idle.Left.name + String($0)) }
                        let idleLeftAction   = SKAction.animate(with: idleLeftTextures, timePerFrame: 0.034)
                        self.run(SKAction.repeatForever(idleLeftAction), withKey: ActionNamingConstant.idle)
                    }
                    break
                case .idleRight:
                    self.removeAction(forKey: ActionNamingConstant.moving)
                    if ( self.action(forKey: ActionNamingConstant.idle) == nil ) {
                        let idleRightTextures : [SKTexture] = (0...30).map { SKTexture(imageNamed: ImageNamingConstant.Player.Idle.Right.name + String($0)) }
                        let idleRightAction   = SKAction.animate(with: idleRightTextures, timePerFrame: 0.034)
                        self.run(SKAction.repeatForever(idleRightAction), withKey: ActionNamingConstant.idle)
                    }
                    break
                case .movingLeft:
                    self.removeAction(forKey: ActionNamingConstant.idle)
                    if ( self.action(forKey: ActionNamingConstant.moving) == nil ) {
                        let movingLeftTextures : [SKTexture] = (0...19).map { SKTexture(imageNamed: ImageNamingConstant.Player.Moving.Left.name + String($0)) }
                        let movingLeftAction   = SKAction.animate(with: movingLeftTextures, timePerFrame: 0.05)
                        self.run(SKAction.repeatForever(movingLeftAction), withKey: ActionNamingConstant.moving)
                    }
                    break
                case .movingRight:
                    self.removeAction(forKey: ActionNamingConstant.idle)
                    if ( self.action(forKey: ActionNamingConstant.moving) == nil ) {
                        let movingRightTextures : [SKTexture] = (0...19).map { SKTexture(imageNamed: ImageNamingConstant.Player.Moving.Right.name + String($0)) }
                        let movingRightAction = SKAction.animate(with: movingRightTextures, timePerFrame: 0.05)
                        self.run(SKAction.repeatForever(movingRightAction), withKey: ActionNamingConstant.moving)
                    }
                    break
                case .jumpingLeft:
                    self.texture = SKTexture(imageNamed: ImageNamingConstant.Player.idleLeft)
                    break
                case .jumpingRight:
                    self.texture = SKTexture(imageNamed: ImageNamingConstant.Player.idleRight)
                    break
                case .climbing:
                    self.texture = SKTexture(imageNamed: ImageNamingConstant.Player.climbing)
                    break
            }
        }
    }
    var previousState : PlayerState = .idleRight
    
    init () {
        self.state = .idleRight
        let texture = SKTexture( imageNamed: ImageNamingConstant.Player.Idle.Right.name )
        
        super.init( texture: texture, color: .clear, size: ValueProvider.playerDimension )
        
        self.name = NodeNamingConstant.player
        self.state = .idleRight
        
        self.physicsBody = SKPhysicsBody( texture: texture, size: ValueProvider.playerPhysicsBodyDimension )
        self.physicsBody?.isDynamic      = GameConfig.playerIsDynamic
        self.physicsBody?.mass           = GameConfig.playerMass
        self.physicsBody?.linearDamping  = GameConfig.playerLinearDamping
        self.physicsBody?.friction       = GameConfig.playerFriction
        self.physicsBody?.allowsRotation = GameConfig.playerRotates
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
