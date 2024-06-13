import SwiftUI
import SpriteKit

class MovementController : SKNode {
    
    let bSize  = UIConfig.SquareSizes.mini + 10
    let hForce = GameConfig.lateralForce
    let vForce = GameConfig.elevationalForce
    let hImpls = GameConfig.lateralImpulse
    let vImpls = GameConfig.elevationalImpulse
    let vImpls2 = GameConfig.elevationalImpulseSecond
    
    let target : SKNode
    @ObservedObject var gameControl: GameControl
    var bLeft  : HoldButtonNode
    var bRight : HoldButtonNode
    var bJump  : PressButtonNode
    var bClimb : HoldButtonNode
    
    init ( target: SKNode, gameControl: GameControl ) {
        self.target = target
        self.gameControl = gameControl
        
        let vForce = self.vForce
        let vImpls = self.vImpls
        let vImpls2 = self.vImpls2
        
        bLeft = HoldButtonNode (
            name: "left controller button",
            imageNamed: "button-left",
            command: {},
            completion: {}
        )
        bLeft.size = CGSize(width: bSize, height: bSize)
        
        bRight = HoldButtonNode (
            name: "right controller button",
            imageNamed: "button-right",
            command: {},
            completion: {}
        )
        bRight.size = CGSize(width: bSize, height: bSize)
        
        bJump = PressButtonNode (
            name: "jump controller button",
            imageNamed: "button-jump",
            command: {}
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
        
        bLeft.command = {
            self.gameControl.heroState = .movingLeft
            target.physicsBody?.velocity = CGVector(dx: gameControl.currentPlatform == .base ? -100 : gameControl.currentPlatform == .slippery ? -125 : -75 , dy: target.physicsBody?.velocity.dy ?? 0)
            //            target.physicsBody?.applyForce(CGVectorMake(-hForce, 0))
        }
        bLeft.completion = {
            target.physicsBody?.velocity = CGVector(dx: 0, dy: target.physicsBody?.velocity.dy ?? 0)
            self.gameControl.heroState = .idleLeft
        }
        
        bRight.command = {
            self.gameControl.heroState = .movingRight
            target.physicsBody?.velocity = CGVector(dx:  gameControl.currentPlatform == .base ? 100 : gameControl.currentPlatform == .slippery ? 125 : 75, dy: target.physicsBody?.velocity.dy ?? 0)
            //            target.physicsBody?.applyForce(CGVectorMake(hForce, 0))
        }
        bRight.completion = {
            target.physicsBody?.velocity = CGVector(dx: 0, dy: target.physicsBody?.velocity.dy ?? 0)
            self.gameControl.heroState = .idleRight
        }
        
        bJump.command = {
            if self.gameControl.jumpCount < 2 {
                if (self.gameControl.jumpCount == 0 && self.gameControl.currentPlatform == .base) {
                    target.physicsBody?.velocity = CGVector(dx: target.physicsBody?.velocity.dx ?? 0, dy: 0)
                    target.physicsBody?.applyImpulse(CGVectorMake(0, vImpls))
                } else {
                    target.physicsBody?.velocity = CGVector(dx: target.physicsBody?.velocity.dx ?? 0, dy: 0)
                    target.physicsBody?.applyImpulse(CGVectorMake(0, vImpls2))
                }
                self.gameControl.currentPlatform = .base
                self.gameControl.jumpCount += 1
            }
        }
    }
    
    /* Inherited from SKNode. Refrain from modifying the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
}
