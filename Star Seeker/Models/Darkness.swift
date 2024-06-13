//
//  Darkness.swift
//  Star Seeker
//
//  Created by Elian Richard on 13/06/24.
//

import SpriteKit

struct DarknessModel {
    let unitSize: CGFloat
    let darknessMoveAction: SKAction
    
    init(unitSize: CGFloat) {
        self.unitSize = unitSize
        self.darknessMoveAction = SKAction.move(to: CGPoint(xGrid: 5, yGrid: 20, unitSize: unitSize), duration: 150)
    }
    
    func addDarkness(unitSize: CGFloat) -> SKSpriteNode {
        let darkness = SKSpriteNode(color: .black, size: CGSize(width: unitSize*100, height: unitSize*50))
        darkness.name = "darkness"
        darkness.position = CGPoint(xGrid: 5, yGrid: -22, unitSize: unitSize)
        darkness.physicsBody = SKPhysicsBody(rectangleOf: darkness.size)
        darkness.physicsBody?.isDynamic = false
        darkness.scene?.backgroundColor = .white
        darkness.physicsBody?.categoryBitMask = CollisionType.darkness.rawValue
        darkness.physicsBody?.collisionBitMask = CollisionType.hero.rawValue
        darkness.physicsBody?.contactTestBitMask = CollisionType.hero.rawValue
        return darkness
    }
}
