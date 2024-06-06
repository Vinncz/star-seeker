import SpriteKit
import SwiftData
import SwiftUI

struct ContentView : View {

    let sw = UIScreen.main.bounds.width
    let sh = UIScreen.main.bounds.height
    
    var scene : SKScene {
        let s = Game()
        s.size = CGSize(width: sw, height: sh)
        s.scaleMode = .fill
        
        let image = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        image.position = CGPoint(x: sw/2, y: sh/2)
        image.physicsBody = SKPhysicsBody(rectangleOf: image.size)
        image.physicsBody?.isDynamic = true
        image.physicsBody?.mass = 0.5
        image.physicsBody?.linearDamping = 1
//        image.physicsBody?.friction = 0.75
        s.addChild(image)

        let platform = SKSpriteNode(color: .green, size: CGSize(width: 2500, height: 250))
        platform.position = CGPoint(x: 0, y: 0)
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.scene?.backgroundColor = .white
        s.addChild(platform)
        
        let floatingPlatform = SKSpriteNode(color: .green, size: CGSize(width: 250, height: 100))
        floatingPlatform.position = CGPoint(x: 0, y: 300)
        floatingPlatform.physicsBody = SKPhysicsBody(rectangleOf: floatingPlatform.size)
        floatingPlatform.physicsBody?.isDynamic = false
        s.addChild(floatingPlatform)
        
        let floatingPlatform2 = SKSpriteNode(color: .cyan, size: CGSize(width: 250, height: 100))
        floatingPlatform2.position = CGPoint(x: 375, y: 300)
        floatingPlatform2.physicsBody = SKPhysicsBody(rectangleOf: floatingPlatform2.size)
        floatingPlatform2.physicsBody?.isDynamic = false
        floatingPlatform2.physicsBody?.friction = 0
        s.addChild(floatingPlatform2)
        
        let floatingPlatform3 = SKSpriteNode(color: .magenta, size: CGSize(width: 150, height: 100))
        floatingPlatform3.position = CGPoint(x: 375, y: 500)
        floatingPlatform3.physicsBody = SKPhysicsBody(rectangleOf: floatingPlatform3.size)
        floatingPlatform3.physicsBody?.isDynamic = false
        floatingPlatform3.physicsBody?.friction = 0.8
        s.addChild(floatingPlatform3)
        
        let movementController = MovementController(target: image)
        movementController.position = CGPoint(x: UIConfig.Paddings.huge, y: UIConfig.Paddings.huge)
        s.addChild(movementController)
        
        return s
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea(.all)
    }
    
}

#Preview {
    ContentView()
}
