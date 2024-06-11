import SpriteKit
import SwiftUI

@Observable class GameControl: ObservableObject {
    var playerState: PlayerState = .idleRight
    var currentPlatform: PlatformTypes = .base
    var jumpCount: Int = 0
    var score: Int = 0
    var lastPlatformY: CGFloat = 0.0
}

enum CollisionType: UInt32 {
    case hero = 1
    case platform = 2
}

class Game : SKScene, SKPhysicsContactDelegate {
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
        physicsWorld.contactDelegate = self
        
        hero = SKSpriteNode(texture: gameControl.playerState.texture.first, size: CGSize(width: unitSize*1.5, height: unitSize*1.5))
        hero.name = "hero"
        hero.position = CGPoint(xGrid: 5, yGrid: 6, unitSize: unitSize)
        
        hero.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: unitSize*0.6, height: unitSize*1.2), center: CGPoint(x: 0, y: -5))
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.mass = 0.25
        hero.physicsBody?.linearDamping = 1
        hero.physicsBody?.friction = 0.6
        hero.physicsBody?.allowsRotation = false
        hero.physicsBody?.categoryBitMask = CollisionType.hero.rawValue
        hero.physicsBody?.collisionBitMask = CollisionType.platform.rawValue
        hero.physicsBody?.contactTestBitMask = CollisionType.platform.rawValue
        hero.physicsBody?.usesPreciseCollisionDetection = true
        hero.physicsBody?.restitution = 0
        addChild(hero)
        
        let platform = SKSpriteNode(color: .green, size: CGSize(width: unitSize*22, height: unitSize*10))
        platform.name = "platform-base"
        platform.position = CGPoint(x: 0, y: 0)
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.scene?.backgroundColor = .white
        platform.physicsBody?.friction = GameConfig.defaultFrictionModifier
        addChild(platform)
        
        let platformArray: [PlatformObject] = [
            PlatformObject(type: .base, x: 5, y: 5),
            PlatformObject(type: .base, x: 6, y: 5),
            PlatformObject(type: .base, x: 7, y: 5),
            
            PlatformObject(type: .sticky, x: 0, y: 8),
            PlatformObject(type: .sticky, x: 1, y: 8),
            PlatformObject(type: .sticky, x: 1, y: 7),
            PlatformObject(type: .sticky, x: 2, y: 7),
            PlatformObject(type: .sticky, x: 3, y: 7),
            
            PlatformObject(type: .base, x: 8, y: 7),
            PlatformObject(type: .base, x: 9, y: 7),
            PlatformObject(type: .base, x: 10, y: 7),
            PlatformObject(type: .base, x: 10, y: 8),
            
            PlatformObject(type: .slippery, x: 5, y: 9),
            PlatformObject(type: .slippery, x: 6, y: 9),
            PlatformObject(type: .slippery, x: 6, y: 10),
            PlatformObject(type: .slippery, x: 7, y: 10),
            
            PlatformObject(type: .base, x: 1, y: 11),
            PlatformObject(type: .base, x: 2, y: 11),
            PlatformObject(type: .base, x: 1, y: 12),
            
            PlatformObject(type: .slippery, x: 4, y: 13),
            PlatformObject(type: .slippery, x: 5, y: 13),
            PlatformObject(type: .slippery, x: 6, y: 13),
            
            PlatformObject(type: .base, x: 8, y: 12),
            PlatformObject(type: .base, x: 9, y: 12),
            PlatformObject(type: .base, x: 9, y: 13),
            PlatformObject(type: .base, x: 10, y: 13),
            
            PlatformObject(type: .sticky, x: 1, y: 15),
            PlatformObject(type: .sticky, x: 2, y: 15),
            
            PlatformObject(type: .base, x: 5, y: 16),
            PlatformObject(type: .base, x: 6, y: 16),
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        let sortedNodes = [nodeA, nodeB].sorted { $0.name ?? "" < $1.name ?? "" }
        let firstNode = sortedNodes[0]
        let secondNode = sortedNodes[1]
        
        if (secondNode.name == PlatformTypes.slippery.name || secondNode.name == PlatformTypes.base.name || secondNode.name == PlatformTypes.sticky.name) && firstNode.name == "hero" {
            if isHeroOnTop(hero: firstNode as! SKSpriteNode, platform: secondNode as! SKSpriteNode) {
                gameControl.jumpCount = 0
                addScore(platform: secondNode as! SKSpriteNode)
                switch secondNode.name {
                case PlatformTypes.base.name:
                    gameControl.currentPlatform = .base
                    return
                case PlatformTypes.slippery.name:
                    gameControl.currentPlatform = .slippery
                    return
                case PlatformTypes.sticky.name:
                    gameControl.currentPlatform = .sticky
                    return
                case .none:
                    return
                case .some(_):
                    return
                }
                
            }
        }
    }
    
    func isHeroOnTop(hero: SKSpriteNode, platform: SKSpriteNode) -> Bool {
        let heroBottom = hero.position.y - hero.size.height / 2
        let platformTop = platform.position.y + platform.size.height / 2
        return heroBottom >= platformTop - 0.8
    }
    
    func addScore (platform: SKSpriteNode) -> Void {
        if gameControl.lastPlatformY < platform.position.y {
            if (gameControl.lastPlatformY == 0) {
                gameControl.lastPlatformY = platform.size.height * 5
            }
            let diff = ((platform.position.y - gameControl.lastPlatformY) / platform.size.height).rounded(toPlaces: 1)
            gameControl.score += Int(diff) * 100
            gameControl.lastPlatformY = platform.position.y
        }
    }
    
    
    func addPlatform(type: PlatformTypes, size: CGFloat, x: Int, y: Int) -> Void {
        let platformSize = CGSize(width: size, height: size)
        let platform = SKSpriteNode(texture: SKTexture(imageNamed: type.texture), size: platformSize)
        platform.name = type.name
        platform.position = CGPoint(xGrid: x, yGrid: y, unitSize: size)
        
        let roundedRectPath = UIBezierPath(roundedRect: CGRect(x: -size * 0.5, y: -size * 0.5, width: size, height: size), cornerRadius: 10).cgPath
        platform.physicsBody = SKPhysicsBody(polygonFrom: roundedRectPath)
        //        platform.physicsBody = SKPhysicsBody(rectangleOf: platformSize)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.friction = type.frictionValue
        platform.physicsBody?.categoryBitMask = CollisionType.platform.rawValue
        platform.physicsBody?.collisionBitMask = CollisionType.hero.rawValue
        platform.physicsBody?.contactTestBitMask = CollisionType.hero.rawValue
        platform.physicsBody?.restitution = 0
        addChild(platform)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
