import SpriteKit
import SwiftUI

@Observable class GameControl: ObservableObject {
    var heroState: HeroState = .idleRight
    var currentPlatform: PlatformTypes = .base
    var jumpCount: Int = 0
    var score: Int = 0
    var lastPlatformY: CGFloat = 0.0
    var fps: Double = 0.0
    var platformPreviousPositions: [SKSpriteNode: CGPoint] = [:]
}

enum CollisionType: UInt32 {
    case hero = 1
    case platform = 2
    case darkness = 3
    case moving = 4
}


class Game : SKScene, SKPhysicsContactDelegate {
    @ObservedObject var gameControl: GameControl
    var unitSize: CGFloat
    let platformModel = PlatformModel()
    let heroModel = HeroModel()
    var darknessModel: DarknessModel
    
    var hero: SKSpriteNode!
    var darkness: SKSpriteNode!
    
    var currentMovingPlatform: SKSpriteNode?
    var currentMovingPlatformPosition: CGPoint?
    
    private var lastUpdateTime: TimeInterval = 0
    
    init(size: CGSize, gameControl: GameControl) {
        self.gameControl = gameControl
        self.unitSize = UIScreen.main.bounds.width / 11
        self.darknessModel = DarknessModel(unitSize: self.unitSize)
        super.init(size: size)
        self.scaleMode = .resizeFill
    }
    
    override func didMove ( to view: SKView ) {
        view.allowsTransparency = true
        view.showsFPS = true
        view.showsNodeCount = true
        self.view!.isMultipleTouchEnabled = true
        self.backgroundColor = .clear
        self.scaleMode = .resizeFill
        physicsWorld.contactDelegate = self
        
        for platform in platformModel.platformArray {
            addChild(platformModel.addPlatform(type: platform.type, unitSize: unitSize, x: platform.x, y: platform.y))
        }
        addChild(platformModel.addHMovingPlatform(xStart: 2, xEnd: 4, y: 18, size: 2, unitSize: unitSize))
        //        addChild(platformModel.addGroundPlatform(unitSize: unitSize))
        
        hero = heroModel.addHero(unitSize: unitSize, gameControl: gameControl)
        addChild(hero)
        
        darkness = darknessModel.addDarkness(unitSize: unitSize)
        addChild(darkness)
        darkness.run(darknessModel.darknessMoveAction, withKey: "movingDarkness")
        
        let movementController = MovementController(target: hero, gameControl: gameControl)
        movementController.position = CGPoint(x: UIConfig.Paddings.huge, y: UIConfig.Paddings.huge * 2)
        
        addChild(movementController)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime > 0 {
            let deltaTime = currentTime - lastUpdateTime
            let fps = 1.0 / deltaTime
            gameControl.fps = fps
        }
        lastUpdateTime = currentTime
        
        if let platform = currentMovingPlatform {
            //            if (platform.action(forKey: "moveRight") != nil) {
            //                hero.position.x += 1 * unitSize / 62
            //            } else if (platform.action(forKey: "moveLeft") != nil) {
            //                hero.position.x -= 1 * unitSize / 60
            //            }
            if let previousPosition = currentMovingPlatformPosition {
                let deltaX = platform.position.x - previousPosition.x
                currentMovingPlatformPosition = platform.position
                hero.position.x += deltaX
                
            } else {
                currentMovingPlatformPosition = currentMovingPlatform?.position
            }
        }
        
        
        
        if (gameControl.heroState == .movingLeft || gameControl.heroState == .movingRight) {
            if hero.action(forKey: "moveHero") == nil {
                let moveAction = SKAction.animate(with: gameControl.heroState.texture, timePerFrame: 0.05)
                hero.run(SKAction.repeatForever(moveAction), withKey: "moveHero")
            }
        } else {
            hero.removeAction(forKey: "moveHero")
        }
        
        if (gameControl.heroState == .idleLeft || gameControl.heroState == .idleRight)  {
            if hero.action(forKey: "idleHero") == nil {
                let moveAction = SKAction.animate(with: gameControl.heroState.texture, timePerFrame: 0.05)
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
        
        if (firstNode.name == "darkness" && secondNode.name == "hero") {
            restartGame()
        }
        
        
        if firstNode.name == "hero" && secondNode.name == PlatformTypes.moving.name {
            if isHeroOnTop(hero: firstNode as! SKSpriteNode, platform: secondNode as! SKSpriteNode) {
                currentMovingPlatform = secondNode as? SKSpriteNode
            }
        }
        
        if (secondNode.name == PlatformTypes.slippery.name || secondNode.name == PlatformTypes.base.name || secondNode.name == PlatformTypes.sticky.name || secondNode.name == PlatformTypes.moving.name) && firstNode.name == "hero" {
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
    
    func didEnd(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        let sortedNodes = [nodeA, nodeB].sorted { $0.name ?? "" < $1.name ?? "" }
        let firstNode = sortedNodes[0]
        let secondNode = sortedNodes[1]
        
        if firstNode.name == "hero" && secondNode.name == PlatformTypes.moving.name {
            currentMovingPlatform = nil
            currentMovingPlatformPosition = nil
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
    
    func restartGame() {
        darkness.removeAction(forKey: "movingDarkness")
        let darknessToInitial = SKAction.move(to: CGPoint(xGrid: 5, yGrid: -22, unitSize: unitSize), duration: 0)
        darkness.run(darknessToInitial)
        let moveAction = SKAction.move(to: CGPoint(xGrid: 5, yGrid: 20, unitSize: unitSize), duration: 150)
        darkness.run(moveAction, withKey: "movingDarkness")
        
        let heroToInitial = SKAction.move(to: CGPoint(xGrid: 5, yGrid: 6, unitSize: unitSize), duration: 0)
        hero.run(heroToInitial)
        
        gameControl.score = 0
        gameControl.lastPlatformY = 0
        gameControl.jumpCount = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
