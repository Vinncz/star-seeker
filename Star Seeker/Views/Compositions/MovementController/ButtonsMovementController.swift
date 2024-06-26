import SpriteKit

class ButtonsMovementController : MovementController {
    
    let bSize  = UIConfig.SquareSizes.mini + 10
    let hForce = GameConfig.lateralForce
    let vForce = GameConfig.elevationalForce
    let hImpls = GameConfig.lateralImpulse
    let vImpls = GameConfig.elevationalImpulse
    
    var bLeft  : HoldButtonNode
    var bRight : HoldButtonNode
    var bJump  : PressButtonNode
    var bClimb : HoldButtonNode
    
    override init ( controls target: Player ) {
        let hForce = self.hForce
        let vForce = self.vForce
        let vImpls = self.vImpls
        
        bLeft = HoldButtonNode (
            name: NodeNamingConstant.Button.leftControl,
            imageNamed: ImageNamingConstant.Interface.Button.MovementControl.left, 
            command: {
                target.facingDirection = .leftward
                switch ( target.previousState ) {
                    case .jumping:
                        target.state = .jumping
                        break
                    default:
                        target.state = .moving
                        break
                }
                
                target.physicsBody?.velocity = CGVector(dx: -100, dy: target.physicsBody?.velocity.dy ?? 0)
                target.physicsBody?.applyForce(CGVectorMake(-hForce, 0))
                debug("\(target) was moved leftward")
            },
            completion: { 
                switch ( target.previousState ) {
                    default:
                        target.state = .idle
                        break
                }
                target.physicsBody?.velocity = CGVector(dx: 0, dy: target.physicsBody?.velocity.dy ?? 0)
            }
        )
        bLeft.size = CGSize(width: bSize, height: bSize)
        
        bRight = HoldButtonNode (
            name: NodeNamingConstant.Button.rightControl,
            imageNamed: ImageNamingConstant.Interface.Button.MovementControl.right, 
            command: { 
                target.facingDirection = .rightward
                switch ( target.previousState ) {
                    case .jumping:
                        target.state = .jumping
                        break
                    default:
                        target.state = .moving
                        break
                }
                
                target.physicsBody?.applyForce(CGVectorMake(hForce, 0))
                target.physicsBody?.velocity = CGVector(dx: 100, dy: target.physicsBody?.velocity.dy ?? 0)
                debug("\(target) was moved rightward")
            },
            completion: { 
                switch ( target.previousState ) {
                    default:
                        target.state = .idle
                        break
                }
                target.physicsBody?.velocity = CGVector(dx: 0, dy: target.physicsBody?.velocity.dy ?? 0)
            }
        )
        bRight.size = CGSize(width: bSize, height: bSize)
        
        bJump = PressButtonNode (
            name: NodeNamingConstant.Button.jumpControl,
            imageNamed: ImageNamingConstant.Interface.Button.MovementControl.jump, 
            maxPressedCount: 2,
            timeIntervalToReset: 0.632,
            command: { 
                switch ( target.previousState ) {
                    case .idle, .moving, .jumping:
                        target.state = .jumping
                        break                     
                    default:
                        target.state = .jumping
                        break
                }
                
                target.physicsBody?.applyImpulse(CGVectorMake(0, vImpls))
                debug("\(target) was moved upward")
            },
            completion: { 
                /* TODO: Only update the target's state after they land */
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.632, execute: {
                    switch ( target.previousState ) {
                        case .idle, .moving, .jumping:
                            target.state = .idle
                            break
                        default:
                            target.state = .idle
                            break
                    }
                })
            }
        )
        bJump.size = CGSize(width: bSize, height: bSize)
        
        bClimb = HoldButtonNode (
            name: NodeNamingConstant.Button.climbControl,
            imageNamed: ImageNamingConstant.Interface.Button.MovementControl.climb, 
            command: { 
                target.state = .climbing
                target.physicsBody?.applyForce(CGVectorMake(0, vForce))
                debug("\(target) was made climbing")
            },
            completion: { 
                switch ( target.previousState ) {
                    default:
                        target.state = .idle
                }
            }
        )
        bClimb.size = CGSize(width: bSize, height: bSize)
        
        let hDiv = NeoWrapper(spacing: UIConfig.Spacings.large, direction: .horizontal)
        hDiv.addSpacedChild(bLeft)
        hDiv.addSpacedChild(bRight)
        
        let vDiv = NeoWrapper(spacing: UIConfig.Spacings.large, direction: .vertical)
        vDiv.addSpacedChild(bClimb)
        vDiv.addSpacedChild(bJump)
        
        let div = NeoWrapper(spacing: UIConfig.Spacings.huge * 1.75, direction: .horizontal)
        div.addSpacedChild(hDiv)
        div.addSpacedChild(vDiv)

        super.init(controls: target)
        addChild(div)
    }
    
    /* Inherited from SKNode. Refrain from modifying the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
}
