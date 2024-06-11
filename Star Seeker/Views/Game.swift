import SpriteKit
import SwiftUI

class GameControl: ObservableObject {
    @Published var isMovingHero = false
}

class Game : SKScene {
    @ObservedObject var gameControl: GameControl
    
    var hero: SKSpriteNode!
    var moveAction: SKAction!
    var jumpAction: SKAction!

    
    init(size: CGSize, gameControl: GameControl) {
        self.gameControl = gameControl
        super.init(size: size)
        self.scaleMode = .resizeFill
    }
    
    override func didMove ( to view: SKView ) {
        let unitSize = UIScreen.main.bounds.width / 11
        view.allowsTransparency = true
        self.view!.isMultipleTouchEnabled = true
        self.backgroundColor = .clear
        self.scaleMode = .resizeFill
        
        

        //jump action
//        let jumpTextures = (1...3).map { SKTexture(imageNamed: "leftJump\($0)") }
//        jumpAction = createAnimateAction(with: jumpTextures)

        let heroTextures = (1...20).map { SKTexture(imageNamed: "left\($0)") }
        hero = SKSpriteNode(texture: SKTexture(imageNamed: "left-standing"), size: CGSize(width: unitSize*1.5, height: unitSize*1.5))
        hero.position = CGPoint(xGrid: 0, yGrid: 11, unitSize: unitSize)
        hero.physicsBody = SKPhysicsBody(rectangleOf: hero.size)
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.mass = 0.25
        hero.physicsBody?.linearDamping = 1
        hero.physicsBody?.friction = 0.6
        hero.physicsBody?.allowsRotation = false
        addChild(hero)
        moveAction = createAnimateAction(with: heroTextures)
        
        let platform = SKSpriteNode(color: .green, size: CGSize(width: unitSize*22, height: unitSize*10))
        platform.position = CGPoint(x: 0, y: 0)
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.scene?.backgroundColor = .white
        platform.physicsBody?.friction = GameConfig.defaultFrictionModifier
        addChild(platform)
        
        let platformArray: [PlatformObject] = [
            PlatformObject(type: .base, x: 0, y: 10),
            PlatformObject(type: .slippery, x: 4, y: 10),
            PlatformObject(type: .slippery, x: 5, y: 10),
            PlatformObject(type: .slippery, x: 6, y: 10),
            PlatformObject(type: .slippery, x: 7, y: 10),
            PlatformObject(type: .slippery, x: 8, y: 10),
            PlatformObject(type: .sticky, x: 0, y: 7),
            PlatformObject(type: .sticky, x: 1, y: 7),
            PlatformObject(type: .sticky, x: 2, y: 7),
            PlatformObject(type: .sticky, x: 3, y: 7),
            PlatformObject(type: .sticky, x: 4, y: 7),
        ]
        
        for platform in platformArray {
            addPlatform(type: platform.type, size: unitSize, x: platform.x, y: platform.y)
        }
        
        let movementController = MovementController(target: hero)
        movementController.position = CGPoint(x: UIConfig.Paddings.huge, y: UIConfig.Paddings.huge * 2)
        addChild(movementController)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameControl.isMovingHero && !hero.hasActions() {
            hero.run(SKAction.repeatForever(moveAction), withKey: "moveHero")
        } else if !gameControl.isMovingHero && hero.hasActions() {
            hero.removeAction(forKey: "moveHero")
        }
    }
    
    func createAnimateAction(with textures: [SKTexture]) -> SKAction {
            let animateAction = SKAction.animate(with: textures, timePerFrame: 0.3)
            return animateAction
        }
    
    func jumpAnimation() {
        let jumpTextures = (1...3).map { SKTexture(imageNamed: "leftJump\($0)") }
        let forwardJumpAction = createAnimateAction(with: jumpTextures)
        let reverseJumpAction = createAnimateAction(with: jumpTextures.reversed())

        let jumpSequence = SKAction.sequence([forwardJumpAction, reverseJumpAction])

        hero.run(jumpSequence)
    }

    
    func addPlatform(type: PlatformTypes, size: CGFloat, x: Int, y: Int) -> Void {
        let platformSize = CGSize(width: size, height: size)
        let platform = SKSpriteNode(texture: SKTexture(imageNamed: type.texture), size: platformSize)
        platform.position = CGPoint(xGrid: x, yGrid: y, unitSize: size)
        platform.physicsBody = SKPhysicsBody(rectangleOf: platformSize)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.friction = type.frictionValue
        addChild(platform)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
