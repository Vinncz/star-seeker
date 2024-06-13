import Foundation

enum BitMaskConstant : UInt32 {
    case player                          = 0b001___000000001
    case platform                        = 0b010___000000000
        case inertPlatform               = 0b010_01__0000000
            case basePlatform            = 0b010_01__0000001
            case dynamicPlatform         = 0b010_01_01_00000
                case movingPlatform      = 0b010_01_01_00001
                case collapsiblePlatform = 0b010_01_01_00010
        case reactivePlatform            = 0b010_10_10_00000
            case slipperyPlatform        = 0b010_10_10_00001
            case stickyPlatform          = 0b010_10_10_00010
        case passThroughPlatform         = 0b010_11__0000000
            case climbablePlatform       = 0b010_11__0000001
    case obstacle                        = 0b100___000000000
        case lethalObstacle              = 0b100_01__0000000
        case nonLethalObstacle           = 0b100_10__0000000
}
