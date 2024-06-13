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
