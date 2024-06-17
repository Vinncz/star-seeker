import Foundation
import SpriteKit

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
    static let elevationalImpulse : CGFloat = 650
    
    static let playerIsDynamic    : Bool    = true
    static let playerMass         : CGFloat = 0.25
    static let playerLinearDamping: CGFloat = 1
    static let playerFriction     : CGFloat = 0.4
    static let playerRotates      : Bool    = false
    
    /** Dictates how much slowing factor a Base platform does to a target */
    static let baseFrictionModifier : CGFloat = 0.2
    /** Dictates how much slowing factor a Slippery platform does to a target */
    static let slipperyFrictionModifier : CGFloat = 0.0    
    /** Dictates how much slowing factor a Sticky platform does to a target */
    static let stickyFrictionModifier   : CGFloat = 0.8
    
    static let joystickSafeArea        : CGFloat = 32
    static let joystickDampeningFactor : CGFloat = 400
    
    static let characterMapping : [String : () -> SKSpriteNode] = [
        "pFN" : { BasePlatform          ( size: ValueProvider.gridDimension ) },
        "pBG" : { BasePlatform          ( size: ValueProvider.gridDimension ) },
        "pBP" : { BasePlatform          ( size: ValueProvider.gridDimension ) },
        "pST" : { StickyPlatform        ( size: ValueProvider.gridDimension ) },
        "pSL" : { SlipperyPlatform      ( size: ValueProvider.gridDimension ) },
        "pCL" : { ClimbablePlatform     ( size: ValueProvider.gridDimension ) },
        /** This value size is ignored temporarily */
        "pMV" : { MovingPlatform        ( size: ValueProvider.gridDimension ) },
        "pMT" : { MovingTrackPlatform   ( size: ValueProvider.gridDimension ) },
        
    ]
}
