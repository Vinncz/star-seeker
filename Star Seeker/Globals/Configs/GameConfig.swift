import Foundation
import SpriteKit

struct GameConfig {
    /** Dictates how much should a movement controller button applies a horizontal force to a target */
    static let lateralForce       : CGFloat = 1000
    /** Dictates how much should a movement controller button applies a horizontal impulse to a target */
    static let lateralImpulse     : CGFloat = 500
    /** Dictates how much should a movement controller button applies a vertical force to a target */
    static let elevationalForce   : CGFloat = 3000
    /** Dictates how much should a movement controller button applies a vertical impulse to a target */
    static let elevationalImpulse : CGFloat = 130
    static let elevationalImpulseSecond: CGFloat = 100
    /** Dictates how much fastening factor a Slippery platform does to a target */
    static let slipperyFrictionModifier : CGFloat = 0.0
    /** Dictates how much slowing factor a Sticky platform does to a target */
    static let stickyFrictionModifier   : CGFloat = 0.55
    /** Dictates how much friction of a base platform does to a target */
    static let defaultFrictionModifier   : CGFloat = 0.2
}


enum PlatformTypes: CaseIterable, Hashable {
    case sticky
    case base
    case slippery
    
    var frictionValue: CGFloat {
        switch self {
        case .sticky: GameConfig.stickyFrictionModifier
        case .base: GameConfig.defaultFrictionModifier
        case .slippery: GameConfig.slipperyFrictionModifier
        }
    }
    
    var name: String {
        switch self {
        case .sticky: "platform-sticky"
        case .base: "platform-base"
        case .slippery: "platform-slippery"
        }
    }
    
    var texture: String {
        switch self {
        case .sticky: "sticky"
        case .base: "base"
        case .slippery: "slippery"
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

enum PlayerState {
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
