import SpriteKit
import SwiftData
import SwiftUI

struct ContentView : View {

    let sw = UIScreen.main.bounds.width
    let sh = UIScreen.main.bounds.height
    
    var scene : SKScene {
        let s = Game()
//        s.size = CGSize(width: sw, height: sh)
        s.scaleMode = .resizeFill
        
        let image = SKSpriteNode(color: .red, size: CGSize(width: sw/9, height: sh/19.5))
        image.position = CGPoint(x: sw/2, y: sh/2)
        image.physicsBody = SKPhysicsBody(rectangleOf: image.size)
        image.physicsBody?.isDynamic = true
        image.physicsBody?.mass = 0.25
        image.physicsBody?.linearDamping = 1
        image.physicsBody?.friction = 0.6
        s.addChild(image)

        let platform = SKSpriteNode(color: .green, size: CGSize(width: 3000, height: 6*(sh/19.5)))
        platform.position = CGPoint(x: 0, y: 0)
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.scene?.backgroundColor = .white
        platform.physicsBody?.friction = 0.2
        s.addChild(platform)
        
//        let floatingPlatform = SKSpriteNode(color: .green, size: CGSize(width: 250, height: (sh/19.5)))
//        floatingPlatform.position = CGPoint(x: 0, y: 3*(sh/19.5))
//        floatingPlatform.physicsBody = SKPhysicsBody(rectangleOf: floatingPlatform.size)
//        floatingPlatform.physicsBody?.isDynamic = false
//        floatingPlatform.physicsBody?.friction = 0.3
//        s.addChild(floatingPlatform)
        
        let floatingPlatform2 = SKSpriteNode(color: .cyan, size: CGSize(width: 250, height: (sh/19.5)))
        floatingPlatform2.position = CGPoint(x: 250, y: 250)
        floatingPlatform2.physicsBody = SKPhysicsBody(rectangleOf: floatingPlatform2.size)
        floatingPlatform2.physicsBody?.isDynamic = false
        floatingPlatform2.physicsBody?.friction = GameConfig.slipperyFrictionModifier
        s.addChild(floatingPlatform2)
        
        let floatingPlatform3 = SKSpriteNode(color: .magenta, size: CGSize(width: 225, height: (sh/19.5)))
        floatingPlatform3.position = CGPoint(x: 300, y: 400)
        floatingPlatform3.physicsBody = SKPhysicsBody(rectangleOf: floatingPlatform3.size)
        floatingPlatform3.physicsBody?.isDynamic = false
        floatingPlatform3.physicsBody?.friction = GameConfig.stickyFrictionModifier
        s.addChild(floatingPlatform3)
        
        let movementController = MovementController(target: image)
        movementController.position = CGPoint(x: UIConfig.Paddings.huge, y: UIConfig.Paddings.huge * 2)
        s.addChild(movementController)
        
        return s
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.blue)
                .ignoresSafeArea(.all)
            SpriteView(scene: scene, options: [.allowsTransparency])
                .ignoresSafeArea(.all)
                .background(.clear)
//                .frame(width: 1.25*(sw/2), height: 1.25*(sh/2))
//                .padding(.bottom, UIConfig.Paddings.huge)
            VStack (spacing: 0) {
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
                gridRow
            }
        }
    }
    
    var gridRow : some View {
        HStack (spacing: 0) {
            gridSquare
            gridSquare
            gridSquare
            gridSquare
            gridSquare
            gridSquare
            gridSquare
            gridSquare
            gridSquare
            gridSquare
            gridSquare
        }
    }
    
    var gridSquare: some View {
        Rectangle()
            .foregroundStyle(.clear)
            .border(.white.opacity(0.25))
            .colorMultiply(.red)
            .frame(width: (sw/9)/1.2, height: (sh/19.5)/1.2)
    }
}

#Preview {
    ContentView()
}


