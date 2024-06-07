import SpriteKit

class MovementController : SKNode {
    
    let bSize  = UIConfig.SquareSizes.mini + 10
    let hForce = GameConfig.lateralForce
    let vForce = GameConfig.elevationalForce
    let hImpls = GameConfig.lateralImpulse
    let vImpls = GameConfig.elevationalImpulse
    
    let target : SKNode
    var bLeft  : HoldButtonNode
    var bRight : HoldButtonNode
    var bJump  : PressButtonNode
    var bClimb : HoldButtonNode
    
    init ( target: SKNode ) {
        self.target = target
        
        let hForce = self.hForce
        let vForce = self.vForce
        let hImpls = self.hImpls
        let vImpls = self.vImpls
        
        bLeft = HoldButtonNode (
            name: "left controller button",
            imageNamed: "button-left", command: {
                target.physicsBody?.applyForce(CGVectorMake(-hForce, 0))
                debug("\(target) was moved leftward")
            }
        )
        bLeft.size = CGSize(width: bSize, height: bSize)
        
        bRight = HoldButtonNode (
            name: "right controller button",
            imageNamed: "button-right", command: { 
                target.physicsBody?.applyForce(CGVectorMake(hForce, 0))
                debug("\(target) was moved rightward")
            }
        )
        bRight.size = CGSize(width: bSize, height: bSize)
        
        bJump = PressButtonNode (
            name: "jump controller button",
            imageNamed: "button-jump", command: { 
                target.physicsBody?.applyImpulse(CGVectorMake(0, vImpls))
                debug("\(target) was moved upward")
            }
        )
        bJump.size = CGSize(width: bSize, height: bSize)
        
        bClimb = HoldButtonNode (
            name: "climb controller button",
            imageNamed: "button-climb", command: { 
                target.physicsBody?.applyForce(CGVectorMake(0, vForce))
                debug("\(target) was made climbing")
            }
        )
        bClimb.size = CGSize(width: bSize, height: bSize)
        
        
        let hDiv = Wrapper(spacing: UIConfig.Spacings.large, direction: .horizontal)
        hDiv.addSpacedChild(bLeft)
        hDiv.addSpacedChild(bRight)
        
        let vDiv = Wrapper(spacing: UIConfig.Spacings.large, direction: .horizontal)
        vDiv.addSpacedChild(bClimb)
        vDiv.addSpacedChild(bJump)
        
        let div = Wrapper(spacing: 196, direction: .horizontal)
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
