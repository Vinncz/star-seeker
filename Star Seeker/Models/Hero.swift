//
//  Player.swift
//  Star Seeker
//
//  Created by Elian Richard on 13/06/24.
//

import SpriteKit

enum HeroState {
    case idleLeft
    case idleRight
    case movingLeft
    case movingRight
    
    var texture: [SKTexture] {
        switch self {
        case .idleLeft:
            return (0...30).map { SKTexture(imageNamed: "standing-left\($0)") }
        case .idleRight:
            return (0...30).map { SKTexture(imageNamed: "standing-right\($0)") }
        case .movingLeft:
            return (0...19).map { SKTexture(imageNamed: "left\($0)") }
        case .movingRight:
            return (0...19).map { SKTexture(imageNamed: "right\($0)") }
        }
        
    }
}

struct HeroModel {
    func addHero(unitSize: CGFloat, gameControl: GameControl) -> SKSpriteNode {
        let hero = SKSpriteNode(texture: gameControl.heroState.texture.first, size: CGSize(width: unitSize*1.5, height: unitSize*1.5))
        hero.name = "hero"
        hero.position = CGPoint(xGrid: 5, yGrid: 6, unitSize: unitSize)
        hero.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: unitSize*0.6, height: unitSize*1.2), center: CGPoint(x: 0, y: -5))
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.mass = 0.25
        hero.physicsBody?.linearDamping = 1
        hero.physicsBody?.friction = 0.6
        hero.physicsBody?.allowsRotation = false
        hero.physicsBody?.categoryBitMask = CollisionType.hero.rawValue
        hero.physicsBody?.collisionBitMask = CollisionType.platform.rawValue | CollisionType.darkness.rawValue | CollisionType.moving.rawValue
        hero.physicsBody?.contactTestBitMask = CollisionType.platform.rawValue | CollisionType.darkness.rawValue |  CollisionType.moving.rawValue
        hero.physicsBody?.usesPreciseCollisionDetection = true
        hero.physicsBody?.restitution = 0
        
        return hero
    }
}
