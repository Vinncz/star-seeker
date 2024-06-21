import Foundation
import SpriteKit

struct GameConfig {
    
    /** Divides the screen into grids with the specified value */
    static let playArea           : CGSize = CGSize( width: 11, height: 23 )
    /** Dictates how much should a movement controller button applies a horizontal force to a target */
    static let lateralForce       : CGFloat = 1250
    /** Dictates how much should a movement controller button applies a horizontal impulse to a target */
    static let lateralImpulse     : CGFloat = 1000
    /** Dictates how much should a movement controller button applies a vertical force to a target */
    static let elevationalForce   : CGFloat = 2350
    /** Dictates how much should a movement controller button applies a vertical impulse to a target */
    static let elevationalImpulse : CGFloat = 1000
    
    static let playerIsDynamic    : Bool    = true
    static let playerMass         : CGFloat = 0.25
    static let playerLinearDamping: CGFloat = 1
    static let playerFriction     : CGFloat = 0.4
    static let playerRotates      : Bool    = false
    
    /** Dictates whether platform can be affected by other physics bodies that came into contact with them */
    static let platformIsDynamic    : Bool    = false
    /** Dictates how much of a force does a platform can bounce an object back */
    static let platformRestitution  : CGFloat = 0
    /** Dictates whether a platform can rotate */
    static let platformRotates      : Bool    = false
    /** Dictates how much slowing factor a Base platform does to a target */
    static let platformFriction     : CGFloat = 0.2
    
    /** Dictates how much slowing factor a Slippery platform does to a target */
    static let slipperyFrictionModifier : CGFloat = 0.0    
    /** Dictates how much slowing factor a Sticky platform does to a target */
    static let stickyFrictionModifier   : CGFloat = 0.8
    
    /** Area where drag inputs are nullified if their distance fall below this threshold */
    static let joystickSafeArea              : CGFloat = 10
    /** Dictates how far can you pull on the joystick knob*/
    static let joystickMaxDistance           : CGFloat = 50
    /** Compensates for the width of the touch, for the joystick's maximum pull distance */
    static let joystickInaccuracyCompensator : CGFloat = 0.9
    /** A factor which reduces the impulse given by pulling on a joystick knob */
    static let joystickDampeningFactor       : CGFloat = 250
    
    static let characterMapping : [String : (Season) -> SKSpriteNode] = [
        "PLY" : { season in 
            Player() 
        },
        "pBG" : { season in 
            Platform(themed: season) 
        },
        "pFN" : { season in 
            LevelChangePlatform(themed: season) 
        },
        "pBP" : { season in 
            BasePlatform(themed: season) 
        },
        "pCP" : { season in 
            CollapsiblePlatform(themed: season) 
        },
        "pMV" : { season in 
            MovingPlatform(themed: season) 
        },
        "pMT" : { season in 
            Platform(themed: season) 
        },
        "pST" : { season in 
            StickyPlatform(themed: season) 
        },
        "pSL" : { season in 
            SlipperyPlatform(themed: season) 
        },
        "pCL" : { season in 
            ClimbablePlatform(themed: season) 
        },
    ]
}
