//
//  Platform.swift
//  Star Seeker
//
//  Created by Elian Richard on 13/06/24.
//

import SpriteKit

enum PlatformTypes: CaseIterable, Hashable {
    case sticky
    case base
    case slippery
    case moving
    
    var frictionValue: CGFloat {
        switch self {
        case .sticky: GameConfig.stickyFrictionModifier
        case .base: GameConfig.defaultFrictionModifier
        case .slippery: GameConfig.slipperyFrictionModifier
        case .moving: 1
        }
    }
    
    var name: String {
        switch self {
        case .sticky: "platform-sticky"
        case .base: "platform-base"
        case .slippery: "platform-slippery"
        case .moving: "platform-moving"
        }
    }
    
    var texture: String {
        switch self {
        case .sticky: "sticky"
        case .base: "base"
        case .slippery: "slippery"
        case .moving: "moving"
        }
    }
}

struct PlatformObject: Identifiable {
    var id: UUID
    var type: PlatformTypes
    var x: Int
    var y: Int
    
    init(type: PlatformTypes, x: Int, y: Int) {
        self.id = UUID()
        self.type = type
        self.x = x
        self.y = y
    }
}

struct PlatformModel {
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
    
    func addPlatform(type: PlatformTypes, unitSize: CGFloat, x: Int, y: Int) -> SKSpriteNode {
        let platformSize = CGSize(width: unitSize, height: unitSize)
        let platform = SKSpriteNode(texture: SKTexture(imageNamed: type.texture), size: platformSize)
        platform.name = type.name
        platform.position = CGPoint(xGrid: x, yGrid: y, unitSize: unitSize)
        
        let roundedRectPath = UIBezierPath(roundedRect: CGRect(x: -unitSize * 0.5, y: -unitSize * 0.5, width: unitSize, height: unitSize), cornerRadius: 10).cgPath
        platform.physicsBody = SKPhysicsBody(polygonFrom: roundedRectPath)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.friction = type.frictionValue
        platform.physicsBody?.categoryBitMask = CollisionType.platform.rawValue
        platform.physicsBody?.collisionBitMask = CollisionType.hero.rawValue
        platform.physicsBody?.contactTestBitMask = CollisionType.hero.rawValue
        platform.physicsBody?.restitution = 0
        return platform
    }

    func addHMovingPlatform(xStart: Int, xEnd: Int, y: Int, size: Int, unitSize: CGFloat) -> SKSpriteNode {
        let platformSize = CGSize(width: CGFloat(size)*unitSize, height: unitSize)
        let platform = SKSpriteNode(texture: SKTexture(imageNamed: "base"), size: platformSize)
        platform.name = PlatformTypes.moving.name
        platform.position = CGPoint(xGrid: xStart, yGrid: y, width: size, height: 1, unitSize: unitSize)
        
        let roundedRectPath = UIBezierPath(roundedRect: CGRect(x: -CGFloat(size)*unitSize * 0.5, y: -unitSize * 0.5, width: CGFloat(size)*unitSize, height: unitSize), cornerRadius: 10).cgPath
        platform.physicsBody = SKPhysicsBody(polygonFrom: roundedRectPath)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.friction = PlatformTypes.moving.frictionValue
        platform.physicsBody?.categoryBitMask = CollisionType.moving.rawValue
        platform.physicsBody?.collisionBitMask = CollisionType.hero.rawValue
        platform.physicsBody?.contactTestBitMask = CollisionType.hero.rawValue
        platform.physicsBody?.restitution = 0
        
        let distance = CGFloat(xEnd) - CGFloat(xStart) - CGFloat(size) + 1
        
        let platformSpeed = 1.0
        let platformActionDuration = distance / platformSpeed
        
        let moveRight = SKAction.moveBy(x: distance * unitSize, y: 0, duration: platformActionDuration)
        let moveLeft = SKAction.moveBy(x: -distance * unitSize, y: 0, duration: platformActionDuration)
        
        let runMoveRight = SKAction.run { platform.run(moveRight, withKey: "moveRight") }
        let runMoveLeft = SKAction.run { platform.run(moveLeft, withKey: "moveLeft") }
        
        let wait = SKAction.wait(forDuration: platformActionDuration)
        
        let sequence = SKAction.sequence([runMoveRight, wait, runMoveLeft, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        
        platform.run(repeatForever, withKey: "movingSequence")
        return platform
    }

    func addGroundPlatform (unitSize: CGFloat) -> SKSpriteNode {
        let groundPlatform = SKSpriteNode(color: .green, size: CGSize(width: unitSize*22, height: unitSize*10))
        groundPlatform.name = "platform-base"
        groundPlatform.position = CGPoint(x: 0, y: 0)
        groundPlatform.physicsBody = SKPhysicsBody(rectangleOf: groundPlatform.size)
        groundPlatform.physicsBody?.isDynamic = false
        groundPlatform.physicsBody?.friction = GameConfig.defaultFrictionModifier
        
        return groundPlatform
    }
}


