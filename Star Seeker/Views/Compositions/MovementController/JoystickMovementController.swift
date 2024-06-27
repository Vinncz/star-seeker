import SpriteKit

class JoystickMovementController : MovementController {
    /** Specifies how large the joystick knob will be */
    let bSize   = UIConfig.SquareSizes.mini + 10
    /** Convenience class-exclusive variable, which gets its value by deriving horizontal impulse value from GameConfig */
    let hImpls   : CGFloat = GameConfig.lateralImpulse
    /** Convenience class-exclusive variable, which gets its value by deriving vertical impulse value from GameConfig */
    let vImpls   : CGFloat = GameConfig.elevationalImpulse
    /** Convenience class-exclusive variable, which gets its value by deriving joystick safe area distance value from GameConfig */
    let joystickSafeArea   : CGFloat = GameConfig.joystickSafeArea
    /** Convenience class-exclusive variable, which gets its value by deriving joystick max area distance value from GameConfig */
    let joystickMaxDistance   : CGFloat = GameConfig.joystickMaxDistance
    
    override var target: Player {
        didSet {
            self.directionIndicator?.removeFromParent()
            target.addChild(self.directionIndicator!)
        }
    }
    
    var directionIndicator : SKShapeNode?
    var bottomController : SKSpriteNode?
    var arrowController : SKSpriteNode?
    
    override init ( controls target : Player ) {
        super.init(controls: target)
        
        self.bottomController = JoystickMovementController.bottomControllerNode(buttonSize: bSize, maxDistance: self.joystickMaxDistance)
        addChild(self.bottomController!)
        
        let joystick      = attachJoystick()
        joystick.size = CGSize(width: bSize, height: bSize)
        addChild(joystick)
        
        self.arrowController = JoystickMovementController.arrowControllerNode(buttonSize: bSize)
        addChild(self.arrowController!)
        
    }
    
    /** Instanciates a draggable button, which will later becomes the joystick knob. */
    private func attachJoystick () -> HoverAwareDragButtonNode {
        let maxDraggableDistance : CGFloat = GameConfig.joystickMaxDistance
        
        return HoverAwareDragButtonNode (
            name       : NodeNamingConstant.movementControls,
            imageNamed : ImageNamingConstant.Interface.Button.MovementControl.Joystick.knob,
            maxDraggableDistance: maxDraggableDistance,
            onTouch    : {
                JoystickMovementController.scaleBottomController(target: (self.bottomController)!, to: 1)
                JoystickMovementController.fadeInOutNode(target: (self.arrowController)!, isFadeIn: false)
                SoundManager.instance.playSound(named: .SlingshotPull, on: self)
            },
            onTouchEnd : {
                JoystickMovementController.scaleBottomController(target: (self.bottomController)!, to: 0)
                JoystickMovementController.fadeInOutNode(target: (self.arrowController)!, isFadeIn: true)
                SoundManager.instance.playSound(named: .SlingshotRelease, on: self)
            },
            command    : { [weak self] deltaX, deltaY in
                switch ( self?.target.state ) {
                    case .moving, .jumping:
                        break
                    default:
                        self?.target.state = .squating
                        break
                }
                
                let deltaDistance = sqrt(deltaX * deltaX + deltaY * deltaY)
                
                let deltasExceedMinimumTreshold =  deltaDistance >= self!.joystickSafeArea
                let deltasExceedMaxTreshold =  deltaDistance >= self!.joystickMaxDistance
                
                /* MARK: Begin arrow logic */
                guard ( deltasExceedMinimumTreshold ) else {
                    self?.directionIndicator?.isHidden = true
                    return
                }
                let angle = atan2(deltaY, deltaX)
                let radius = (self?.target.size.height)! - 20
                let indicatorPosition = CGPoint(
                    x: radius * -cos(angle),
                    y: radius * -sin(angle)
                )
                let resultingImpulse = CGVector (
                    dx: -1 * (deltaX / GameConfig.joystickDampeningFactor) * (self!.hImpls),
                    dy: -1 * (deltaY / GameConfig.joystickDampeningFactor) * (self!.vImpls)
                )
                self?.directionIndicator?.removeFromParent()
                let directionIndicatorNode = JoystickMovementController.defaultDirectionIndicator(impulse: resultingImpulse, startingPosition: indicatorPosition)
                self?.directionIndicator = directionIndicatorNode
                if let targetNode = self?.target {
                    targetNode.addChild(directionIndicatorNode)
                }
                /* MARK: End arrow logic */
                
                if ( deltasExceedMinimumTreshold ) {
                    self!.commenceVibration(force: .light)
                } else if ( deltasExceedMaxTreshold ) {
                    self!.commenceVibration(force: .heavy)
                }
            },
            completion : { [weak self] deltaX, deltaY in
                self?.directionIndicator?.isHidden = true
                guard let target = self?.target else { return }
                
                let deltaDistance = sqrt(deltaX * deltaX + deltaY * deltaY)
                let deltasExceedMinimumTreshold =  deltaDistance >= self!.joystickSafeArea
                guard ( deltasExceedMinimumTreshold ) else {
                    target.state = .idle
                    target.restrictions.list.removeValue(forKey: RestrictionConstant.Player.jump)
                    return
                }
                
                /* MARK: -- From this point on, pull distance is guaranteed to move the player around */
                
                guard ( target.restrictions.list[RestrictionConstant.Player.jump] == nil ) else { return }
                
                let snapshotOfNodesWhichCollidedWithPlayer = target.statistics!.currentlyStandingOn
                
                let resultingImpulse = CGVector (
                    dx: -1 * (deltaX / GameConfig.joystickDampeningFactor) * (self!.hImpls),
                    dy: -1 * (deltaY / GameConfig.joystickDampeningFactor) * (self!.vImpls)
                )
                target.facingDirection = deltaX > 0 ? .leftward : .rightward
                target.physicsBody?.applyImpulse(resultingImpulse)
                
                if ( target.statistics!.currentlyStandingOn == snapshotOfNodesWhichCollidedWithPlayer ) {
                    target.state = .idle
                }
            }
        )
    }
    
    static func scaleBottomController (target: SKSpriteNode, to: Double) {
        let scaleAction = SKAction.scale(to: to, duration: 0.2)
        target.run(scaleAction, withKey: "scaleBottomController")
    }
    
    static func defaultDirectionIndicator (impulse: CGVector, startingPosition: CGPoint) -> SKShapeNode {
        let points = calculateTrajectoryPoints(impulse: impulse, startingPosition: startingPosition)
        let dashedPath = createDashedPath(points: points, lineWidth: 2.0, dashLength: 10.0, gapLength: 5.0)
        
        let path = CGMutablePath()
        path.addLines(between: points)
        
        let shapeNode = SKShapeNode(path: dashedPath)
        shapeNode.strokeColor = .white
        shapeNode.lineWidth = 3.0
        shapeNode.zPosition = 20
        
        return shapeNode
        
    }
    
    static func createDashedPath(points: [CGPoint], lineWidth: CGFloat, dashLength: CGFloat, gapLength: CGFloat) -> CGPath {
        let path = CGMutablePath()
        if (points.count == 0) {
            return path
        }
        var currentPoint = points[0]
        path.move(to: currentPoint)

        var isDrawing = true
        var distanceRemaining: CGFloat = dashLength
        
        for i in 0..<points.count {
            let nextPoint = points[i]
            let segmentVector = CGVector(dx: nextPoint.x - currentPoint.x, dy: nextPoint.y - currentPoint.y)
            let segmentLength = sqrt(segmentVector.dx * segmentVector.dx + segmentVector.dy * segmentVector.dy)
            var segmentProgress: CGFloat = 0

            while segmentProgress < segmentLength {
                let drawLength = min(distanceRemaining, segmentLength - segmentProgress)
                let drawVector = CGVector(dx: segmentVector.dx * drawLength / segmentLength, dy: segmentVector.dy * drawLength / segmentLength)
                let drawPoint = CGPoint(x: currentPoint.x + drawVector.dx, y: currentPoint.y + drawVector.dy)

                if isDrawing {
                    path.addLine(to: drawPoint)
                } else {
                    path.move(to: drawPoint)
                }

                currentPoint = drawPoint
                segmentProgress += drawLength
                distanceRemaining -= drawLength

                if distanceRemaining <= 0 {
                    isDrawing = !isDrawing
                    distanceRemaining = isDrawing ? dashLength : gapLength
                }
            }
        }

        return path
    }
    
    static func calculateTrajectoryPoints(impulse: CGVector, startingPosition: CGPoint) -> [CGPoint] {
        var points = [CGPoint]()
        
        let gravity = CGVectorMake(0, -9.8)
        let mass = GameConfig.playerMass
        let initialVelocity = CGVector(dx: impulse.dx * mass, dy: impulse.dy * mass)
        
        let numberOfPoints = 50
        let timeStep = 0.1
        
        for i in 0..<numberOfPoints {
            let t = Double(i) * timeStep
            let x = initialVelocity.dx * CGFloat(t)
            let y = initialVelocity.dy * CGFloat(t) + 0.5 * gravity.dy * CGFloat(t * t)
            let point = CGPoint(x: x, y: y)
            if (point.getDistance() > startingPosition.getDistance()) {
                points.append(point)
            }
        }
        
        return points
    }
    
    static func fadeInOutNode (target: SKSpriteNode, isFadeIn: Bool) {
        var action: SKAction
        var key: String
        if (isFadeIn) {
            action = SKAction.fadeIn(withDuration: 0.2)
            key = "fadeIn"
        } else {
            action = SKAction.fadeOut(withDuration: 0.2)
            key = "fadeOut"
        }
        target.run(action, withKey: "\(key)\(String(describing: target.name))")
    }
    
    static func defaultDirectionIndicator ( to target: SKSpriteNode ) -> SKSpriteNode {
        let arrowTexture            = SKTexture( image: UIImage(systemName: "arrowshape.up.fill")! )
        let directionIndicator      = SKSpriteNode( texture: arrowTexture, size: arrowTexture.size() )
        directionIndicator.isHidden = true
        directionIndicator.size     = CGSize( width: 35, height: 35 )
        directionIndicator.position = CGPoint( x: 0, y: 0 )
        
        return directionIndicator
    }
    
    static func arrowControllerNode (buttonSize: Double) -> SKSpriteNode {
        let arrowControllerTexture = SKTexture(imageNamed: ImageNamingConstant.Interface.Button.MovementControl.Joystick.pullDownIndicator)
        let arrowController        = SKSpriteNode(texture: arrowControllerTexture, color: .clear, size: arrowControllerTexture.size())
        arrowController.size       = CGSize(width: buttonSize, height: buttonSize)
        arrowController.position   = CGPoint(x: 0, y: -(buttonSize + 20))
        arrowController.name       = "arrowController"
        
        return arrowController
    }
    
    static func bottomControllerNode (buttonSize: Double, maxDistance: Double) -> SKSpriteNode {
        let bottomControllerTexture = SKTexture(imageNamed: ImageNamingConstant.Interface.Button.MovementControl.Joystick.dragAreaIndicator)
        let bottomController = SKSpriteNode(texture: bottomControllerTexture, color: .clear, size: bottomControllerTexture.size())
        bottomController.setScale(0)
        bottomController.size = CGSize(width: (buttonSize * 2) + maxDistance, height: (buttonSize * 2) + maxDistance)
        
        return bottomController
    }
    
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
