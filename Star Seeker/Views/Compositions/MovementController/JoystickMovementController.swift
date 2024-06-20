import SpriteKit

class JoystickMovementController : MovementController {
    
    override var target: Player {
        didSet {
            self.directionIndicator?.removeFromParent()
            target.addChild(self.directionIndicator!)
        }
    }
    var directionIndicator : SKSpriteNode?
    var bottomController : SKSpriteNode?
    
    override init ( controls target : Player ) {        
        self.hImpls = GameConfig.lateralImpulse
        self.vImpls = GameConfig.elevationalImpulse
        
        self.directionIndicator = JoystickMovementController.defaultDirectionIndicator(to: target)
        
        super.init(controls: target)
        
        let joystick      = attachJoystick()
            joystick.size = CGSize(width: bSize, height: bSize)
        
        target.addChild(directionIndicator!)
        
        let bottomControllerTexture = SKTexture(imageNamed: ImageNamingConstant.Interface.Joystick.bottom)
        self.bottomController = SKSpriteNode(texture: bottomControllerTexture, color: .clear, size: bottomControllerTexture.size())
        addChild(bottomController!)
        
        addChild(joystick)
    }
    
    /** Instanciates a draggable button, which will later becomes the joystick knob. */
    private func attachJoystick () -> DragButtonNode {
        let maxDraggableDistance : CGFloat = GameConfig.joystickMaxDistance
        
        return DragButtonNode (
            name       : NodeNamingConstant.movementControls,
            imageNamed : ImageNamingConstant.Interface.Joystick.top,
            maxDraggableDistance: maxDraggableDistance,
            command    : { [weak self] deltaX, deltaY in
                switch ( self?.target.state ) {
                    case .moving, .jumping:
                        break                     
                    default:
                        self?.target.state = .squating
                        break
                }
                
                let bothDeltasExceedMinimumTreshold =  deltaX < -GameConfig.joystickSafeArea || deltaX > GameConfig.joystickSafeArea || deltaY < -GameConfig.joystickSafeArea || deltaY > GameConfig.joystickSafeArea
                guard ( bothDeltasExceedMinimumTreshold ) else { 
                    self?.directionIndicator?.isHidden = true
                    return
                }
                
                /* MARK: Begin arrow logic */
                    self?.directionIndicator?.isHidden = false
                    let angle = atan2(deltaY, deltaX)
                    self?.directionIndicator?.zRotation = angle + .pi / 2

                    let distanceAr = sqrt(deltaX * deltaX + deltaY * deltaY)
                    let scale = distanceAr / maxDraggableDistance
                    self?.directionIndicator?.xScale = scale
                    self?.directionIndicator?.yScale = scale
                
                    let radius = self?.target.size.height ?? 0
                    self?.directionIndicator?.position = CGPoint(
                        x: radius * -cos(angle),
                        y: radius * -sin(angle)
                    )
                /* MARK: End arrow logic */
                
                if ( bothDeltasExceedMinimumTreshold ) {
                    self?.commenceVibration(force: .soft)
                } 
                
                let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
                let deltasAreNearingTheirMaximumAllowedValue = distance >= maxDraggableDistance * GameConfig.joystickInaccuracyCompensator
                if ( deltasAreNearingTheirMaximumAllowedValue ) {
                    self?.commenceVibration(force: .heavy)
                }
            },
            completion : { [weak self] deltaX, deltaY in
                self?.directionIndicator?.isHidden = true
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
    
    static func defaultDirectionIndicator ( to target: SKSpriteNode ) -> SKSpriteNode {
        let arrowTexture                = SKTexture( image: UIImage(systemName: "arrowshape.up.fill")! )
        let directionIndicator          = SKSpriteNode( texture: arrowTexture, size: arrowTexture.size() )
            directionIndicator.isHidden = true
            directionIndicator.size     = CGSize( width: 50, height: 50 )
            directionIndicator.position = CGPoint( x: target.position.x, y: target.position.y + target.size.height )
        
        return directionIndicator
    }
    
    /** Specifies how large the joystick knob will be */
    let bSize   = UIConfig.SquareSizes.mini + 10
    /** Convenience class-exclusive variable, which gets its value by deriving horizontal impulse value from GameConfig */
    let hImpls   : CGFloat
    /** Convenience class-exclusive variable, which gets its value by deriving vertical impulse value from GameConfig */
    let vImpls   : CGFloat
    
    /** Convenience method to trigger a vibration */
    private func commenceVibration ( force: UIImpactFeedbackGenerator.FeedbackStyle ) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: force)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
}
