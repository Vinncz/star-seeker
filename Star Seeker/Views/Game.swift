import SpriteKit
import SwiftUI

class GameControl: ObservableObject {
    @Published var playerState: PlayerState = .idleRight
}

class Game : SKScene {
    @ObservedObject var gameControl: GameControl
    
    var hero: SKSpriteNode!
    
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
        
        hero = SKSpriteNode(texture: gameControl.playerState.texture.first, size: CGSize(width: unitSize*1.5, height: unitSize*1.5))
        hero.position = CGPoint(xGrid: 0, yGrid: 11, unitSize: unitSize)
        hero.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: unitSize*0.6, height: unitSize*1.2), center: CGPoint(x: 0, y: -5))
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.mass = 0.25
        hero.physicsBody?.linearDamping = 1
        hero.physicsBody?.friction = 0.6
        hero.physicsBody?.allowsRotation = false
        addChild(hero)
        
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
            PlatformObject(type: .sticky, x: 0, y: 8),
            PlatformObject(type: .sticky, x: 1, y: 7),
            PlatformObject(type: .sticky, x: 2, y: 7),
            PlatformObject(type: .sticky, x: 3, y: 7),
            PlatformObject(type: .sticky, x: 4, y: 7),
        ]
        
        for platform in platformArray {
            addPlatform(type: platform.type, size: unitSize, x: platform.x, y: platform.y)
        }
        
        let movementController = MovementController(target: hero, gameControl: gameControl)
        movementController.position = CGPoint(x: UIConfig.Paddings.huge, y: UIConfig.Paddings.huge * 2)
        addChild(movementController)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (gameControl.playerState == .movingLeft || gameControl.playerState == .movingRight) {
            if hero.action(forKey: "moveHero") == nil {
                print("move action")
                let moveAction = SKAction.animate(with: gameControl.playerState.texture, timePerFrame: 0.05)
                hero.run(SKAction.repeatForever(moveAction), withKey: "moveHero")
            }
        } else {
            hero.removeAction(forKey: "moveHero")
        }
        
        if (gameControl.playerState == .idleLeft || gameControl.playerState == .idleRight)  {
            if hero.action(forKey: "idleHero") == nil {
                let moveAction = SKAction.animate(with: gameControl.playerState.texture, timePerFrame: 0.05)
                hero.run(SKAction.repeatForever(moveAction), withKey: "idleHero")
            }
        } else {
            hero.removeAction(forKey: "idleHero")
        }

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
