import SpriteKit

class JoystickMovementController : MovementController {
    
    override init ( controls target : Player ) {        
        self.hImpls = GameConfig.lateralImpulse
        self.vImpls = GameConfig.elevationalImpulse
        
        super.init(controls: target)
        
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
                guard let target = self?.target else { return }
                
                let deltaXIsLessThanTreshold : Bool = deltaX >= -GameConfig.joystickSafeArea && deltaX <= GameConfig.joystickSafeArea
                let deltaYIsLessThanTreshold : Bool = deltaY >= -GameConfig.joystickSafeArea && deltaY <= GameConfig.joystickSafeArea
                guard ( !( deltaXIsLessThanTreshold && deltaYIsLessThanTreshold ) ) else { 
                    target.state = .idle
                    target.restrictions.list.removeValue(forKey: RestrictionConstant.Player.jump)
                    return 
                }
                
                guard ( target.restrictions.list[RestrictionConstant.Player.jump] == nil ) else { return }
                
                let snapshotOfNodesWhichCollidedWithPlayer = target.statistics!.currentlyStandingOn
                
                let resultingImpulse = CGVector (
                    dx: -1 * (deltaX / GameConfig.joystickDampeningFactor) * (self?.hImpls ?? 0), 
                    dy: -1 * (deltaY / GameConfig.joystickDampeningFactor) * (self?.vImpls ?? 0)
                )
                target.facingDirection = deltaX > 0 ? .leftward : .rightward
                target.physicsBody?.applyImpulse(resultingImpulse)
                
                if ( target.statistics!.currentlyStandingOn == snapshotOfNodesWhichCollidedWithPlayer ) {
                    target.state = .idle
                }
            }
        )
    }
    
    /** Specifies how large the joystick knob will be */
    let bSize   = UIConfig.SquareSizes.mini + 10
    /** Convenience class-exclusive variable, which gets its value by deriving horizontal impulse value from GameConfig */
    let hImpls   : CGFloat
    /** Convenience class-exclusive variable, which gets its value by deriving vertical impulse value from GameConfig */
    let vImpls   : CGFloat
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
}
