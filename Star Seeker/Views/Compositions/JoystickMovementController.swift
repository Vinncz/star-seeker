import SpriteKit

class JoystickMovementController : SKNode {
    
    init ( controls target : Player ) {
        self.target = target
        
        self.hImpls = GameConfig.lateralImpulse
        self.vImpls = GameConfig.elevationalImpulse
        
        super.init()
        
        let joystick      = attachJoystick()
            joystick.size = CGSize(width: bSize, height: bSize)
        
        addChild(joystick)
    }
    
    /** Instanciates a draggable button, which will later becomes the joystick knob. */
    private func attachJoystick () -> DragButtonNode {
        return DragButtonNode (
            name       : NodeNamingConstant.movementControls,
            imageNamed : ImageNamingConstant.Button.jump,
            command    : { [weak self] deltaX, deltaY in
                switch ( self?.target.state ) {
                    case .moving, .jumping:
                        break                     
                    default:
                        self?.target.state = .squating
                        break
                }
                
                if ( deltaX < -GameConfig.joystickSafeArea || deltaX > GameConfig.joystickSafeArea || deltaY < -GameConfig.joystickSafeArea || deltaY > GameConfig.joystickSafeArea) {
                    let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
                    feedbackGenerator.prepare()
                    feedbackGenerator.impactOccurred()
                }
            },
            completion : { [weak self] deltaX, deltaY in
                
                let deltaXIsLessThanTreshold : Bool = deltaX >= -GameConfig.joystickSafeArea && deltaX <= GameConfig.joystickSafeArea
                let deltaYIsLessThanTreshold : Bool = deltaY >= -GameConfig.joystickSafeArea && deltaY <= GameConfig.joystickSafeArea
                guard ( !( deltaXIsLessThanTreshold && deltaYIsLessThanTreshold ) ) else { 
                    self?.target.state = .idle
                    self?.target.restrictions.list.removeValue(forKey: RestrictionConstant.Player.jump)
                    return 
                }
                
                let noRestrictionOnJumping = self?.target.restrictions.list[RestrictionConstant.Player.jump] == nil
                
                if ( noRestrictionOnJumping ) {
                    let resultingImpulse = CGVector (
                        dx: -1 * (deltaX / GameConfig.joystickDampeningFactor) * (self?.hImpls ?? 0), 
                        dy: -1 * (deltaY / GameConfig.joystickDampeningFactor) * (self?.vImpls ?? 0)
                    )
                    
                    self?.target.facingDirection = deltaX > 0 ? .leftward : .rightward
                    
                    self?.target.physicsBody?.applyImpulse( resultingImpulse )
                    self?.target.state = .jumping
                    
                    self?.target.restrictions.list[RestrictionConstant.Player.jump] = PlayerRestriction( comparer: {
                        /* if the player isn't standing on any platform, then they shouldn't jump */
                        self?.target.statistics.currentlyStandingOn == nil 
                    } )
                    
                } else {
                    /* MARK: -- FOR MITIGATION AGAINST "BEING STUCK IN JUMPING STATE" */
                    
                    let conditionB = self?.target.statistics.currentlyStandingOn == nil 
                    if ( conditionB ) {
                        print("masuk b \(conditionB)")
                        let resultingImpulse = CGVector (
                            dx: -1 * (deltaX / GameConfig.joystickDampeningFactor) * (self?.hImpls ?? 0), 
                            dy: -1 * (deltaY / GameConfig.joystickDampeningFactor) * (self?.vImpls ?? 0)
                        )
                        
                        self?.target.facingDirection = deltaX > 0 ? .leftward : .rightward
                        
                        self?.target.physicsBody?.applyImpulse( resultingImpulse )
                        self?.target.state = .jumping
                        
                        self?.target.restrictions.list[RestrictionConstant.Player.jump] = PlayerRestriction( comparer: {
                            /* if the player isn't standing on any platform, then they shouldn't jump */
                            self?.target.statistics.currentlyStandingOn == nil 
                        } )
                    }

                }
//                guard ( conditionB ) else { return }                
            }
        )
    }
    
    /** Specifies how large the joystick knob will be */
    let bSize   = UIConfig.SquareSizes.mini + 10
    /** Reference to an SKNode which an instance of Joystick will control */
    let target   : Player
    /** Convenience class-exclusive variable, which gets its value by deriving horizontal impulse value from GameConfig */
    let hImpls   : CGFloat
    /** Convenience class-exclusive variable, which gets its value by deriving vertical impulse value from GameConfig */
    let vImpls   : CGFloat
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
}
