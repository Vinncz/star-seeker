import SpriteKit

class MovementController : SKNode {
    
    let bSize  = UIConfig.SquareSizes.mini + 10
    let hForce = GameConfig.lateralForce
    let vForce = GameConfig.elevationalForce
    let hImpls = GameConfig.lateralImpulse
    let vImpls = GameConfig.elevationalImpulse
    
    let target : Player
    var bLeft  : HoldButtonNode
    var bRight : HoldButtonNode
    var bJump  : PressButtonNode
    var bClimb : HoldButtonNode
    
    init ( controls target: Player ) {
        self.target = target
        
        let hForce = self.hForce
        let vForce = self.vForce
        let hImpls = self.hImpls
        let vImpls = self.vImpls
        
        bLeft = HoldButtonNode (
            name: "left controller button",
            imageNamed: ImageNamingConstant.Button.left, command: {
                
                switch ( target.previousState ) {
                    case .jumpingRight:
                        target.state = .jumpingLeft
                    
                    default:
                        target.state = .movingLeft
                    
                }
                
                target.physicsBody?.applyForce(CGVectorMake(-hForce, 0))
                debug("\(target) was moved leftward")
            }
        )
        bLeft.size = CGSize(width: bSize, height: bSize)
        
        bRight = HoldButtonNode (
            name: "right controller button",
            imageNamed: ImageNamingConstant.Button.right, command: { 
                
                switch ( target.previousState ) {
                    case .jumpingLeft:
                        target.state = .jumpingRight
                    
                    default:
                        target.state = .movingRight
                    
                }
                
                target.physicsBody?.applyForce(CGVectorMake(hForce, 0))
                debug("\(target) was moved rightward")
            }
        )
        bRight.size = CGSize(width: bSize, height: bSize)
        
        bJump = PressButtonNode (
            name: "jump controller button",
            imageNamed: ImageNamingConstant.Button.jump, command: { 
                
                switch ( target.previousState ) {
                    case .idleLeft, .movingLeft, .jumpingLeft, .climbing:
                        target.state = .jumpingLeft
                    
                    default:
                        target.state = .jumpingRight
                    
                }
                
                target.physicsBody?.applyImpulse(CGVectorMake(0, vImpls))
                debug("\(target) was moved upward")
            }
        )
        bJump.size = CGSize(width: bSize, height: bSize)
        
        bClimb = HoldButtonNode (
            name: "climb controller button",
            imageNamed: ImageNamingConstant.Button.climb, command: { 
                target.state = .climbing
                target.physicsBody?.applyForce(CGVectorMake(0, vForce))
                debug("\(target) was made climbing")
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

        super.init()
        addChild(div)
    }
    
    /* Inherited from SKNode. Refrain from modifying the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
}
