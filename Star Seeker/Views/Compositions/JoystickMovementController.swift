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
                guard ( self?.target.restrictions.list[RestrictionConstant.Player.jump] == nil ) else { return }
                
                let resultingImpulse = CGVector(
                    dx: -1 * (deltaX * 0.0025) * (self?.hImpls ?? 0), 
                    dy: -1 * (deltaY * 0.0025) * (self?.vImpls ?? 0)
                )
                
                if ( deltaX > 0 ) {
                    self?.target.facingDirection = .leftward
                } else {
                    self?.target.facingDirection = .rightward                    
                }
                
                self?.target.physicsBody?.applyImpulse( resultingImpulse )
                switch ( self?.target.previousState ) {
                    case .idle, .moving, .jumping:
                        self?.target.state = .jumping
                        break                     
                    default:
                        self?.target.state = .idle
                        break
                }
                
                self?.target.restrictions.list[RestrictionConstant.Player.jump] = PlayerRestriction( comparer: {
                    self?.target.state == .jumping
                } )
            }
        )
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
}
