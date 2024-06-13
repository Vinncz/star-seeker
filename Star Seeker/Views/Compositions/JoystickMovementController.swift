import SpriteKit

class JoystickMovementController : SKNode {
    
    let bSize  = UIConfig.SquareSizes.mini + 10
    
    let target   : Player
    let hImpls   : CGFloat
    let vImpls   : CGFloat
    
    init ( controls target : Player ) {
        self.target = target
        
        self.hImpls = GameConfig.lateralImpulse
        self.vImpls = GameConfig.elevationalImpulse
        
        super.init()
        let joystick = attachJoystick()
        joystick.size = CGSize(width: bSize, height: bSize)
        addChild(joystick)
        let initialPos = SKSpriteNode( color: .red, size: CGSize(width: 10, height: 10) )
        addChild(initialPos)
    }
    
    func attachJoystick () -> DragButtonNode {
        return DragButtonNode (
            name: "JOYSTICK",
            imageNamed: ImageNamingConstant.Button.jump,
            command: { [weak self] deltaX, deltaY in
                // nothing for now -- player will squat
            },
            completion: { [weak self] deltaX, deltaY in
                self?.target.physicsBody?.applyImpulse(
                    CGVector(
                        dx: -1 * (deltaX * 0.0025) * (self?.hImpls ?? 0), 
                        dy: -1 * (deltaY * 0.0025) * (self?.vImpls ?? 0)
                    )
                )
                switch ( self?.target.previousState ) {
                    case .idleLeft, .movingLeft, .jumpingLeft:
                        self?.target.state = .jumpingLeft
                        break
                    case .idleRight, .movingRight, .jumpingRight:
                        self?.target.state = .jumpingRight
                        break                        
                    default:
                        self?.target.state = .jumpingRight
                        break
                }
            }
        )
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
}
