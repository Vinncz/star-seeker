import Foundation

struct GameConfig {
    
    /** Divides the screen into grids with the specified value */
    static let playArea           : CGSize = CGSize( width: 11, height: 23 )
    
    /** Dictates how much should a movement controller button applies a horizontal force to a target */
    static let lateralForce       : CGFloat = 1250
    /** Dictates how much should a movement controller button applies a horizontal impulse to a target */
    static let lateralImpulse     : CGFloat = 500
    /** Dictates how much should a movement controller button applies a vertical force to a target */
    static let elevationalForce   : CGFloat = 2350
    /** Dictates how much should a movement controller button applies a vertical impulse to a target */
    static let elevationalImpulse : CGFloat = 100
    
    static let playerIsDynamic    : Bool    = true
    static let playerMass         : CGFloat = 0.25
    static let playerLinearDamping: CGFloat = 1
    static let playerFriction     : CGFloat = 0.4
    static let playerRotates      : Bool    = false
    
    /**  */
    static let baseFrictionModifier : CGFloat = 0.2
    /** Dictates how much fastening factor a Slippery platform does to a target */
    static let slipperyFrictionModifier : CGFloat = 0.0    
    /** Dictates how much slowing factor a Sticky platform does to a target */
    static let stickyFrictionModifier   : CGFloat = 0.8
    
}
