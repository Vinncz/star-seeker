import Foundation

struct GameConfig {
    
    /** Dictates how much should a movement controller button applies a horizontal force to a target */
    static let lateralForce       : CGFloat = 1500
    /** Dictates how much should a movement controller button applies a horizontal impulse to a target */
    static let lateralImpulse     : CGFloat = 500
    /** Dictates how much should a movement controller button applies a vertical force to a target */
    static let elevationalForce   : CGFloat = 6000
    /** Dictates how much should a movement controller button applies a vertical impulse to a target */
    static let elevationalImpulse : CGFloat = 250
    
}
