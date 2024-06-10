import SpriteKit

class Player : SKSpriteNode {
    
    var state         : PlayerState {
        didSet {
            debug("player's state: \(state)")
            previousState = oldValue
            
            switch state {
                case .idleLeft:
                    self.texture = SKTexture(imageNamed: ImageNamingConstant.Player.idleLeft)
                case .idleRight:
                    self.texture = SKTexture(imageNamed: ImageNamingConstant.Player.idleRight)
                case .movingLeft:
                    self.texture = SKTexture(imageNamed: ImageNamingConstant.Player.idleLeft)
                case .movingRight:
                    self.texture = SKTexture(imageNamed: ImageNamingConstant.Player.idleRight)
                case .jumpingLeft:
                    self.texture = SKTexture(imageNamed: ImageNamingConstant.Player.idleLeft)
                case .jumpingRight:
                    self.texture = SKTexture(imageNamed: ImageNamingConstant.Player.idleRight)
                case .climbing:
                    self.texture = SKTexture(imageNamed: ImageNamingConstant.Player.climbing)
            }
        }
    }
    var previousState : PlayerState = .idleRight
    
    init () {
        self.state = .idleRight
        let texture = SKTexture(imageNamed: ImageNamingConstant.Player.idleRight)
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.name = NodeNamingConstant.player
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.isDynamic = true
        self.physicsBody?.mass = 0.25
        self.physicsBody?.linearDamping = 1
        self.physicsBody?.friction = 0.6
        self.physicsBody?.allowsRotation = false
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
