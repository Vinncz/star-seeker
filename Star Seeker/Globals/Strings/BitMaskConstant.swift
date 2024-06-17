import Foundation

struct BitMaskConstant {
    static let player                          : UInt32 = 0b001___000000001
    static let platform                        : UInt32 = 0b010___000000000
        static let inertPlatform               : UInt32 = 0b010_01__0000000
            static let basePlatform            : UInt32 = 0b010_01__0000001
            static let dynamicPlatform         : UInt32 = 0b010_01_01_00000
                static let movingPlatform      : UInt32 = 0b010_01_01_00001
                static let collapsiblePlatform : UInt32 = 0b010_01_01_00010
        static let reactivePlatform            : UInt32 = 0b010_10_10_00000
            static let slipperyPlatform        : UInt32 = 0b010_10_10_00001
            static let stickyPlatform          : UInt32 = 0b010_10_10_00010
        static let passThroughPlatform         : UInt32 = 0b010_11__0000000
            static let climbablePlatform       : UInt32 = 0b010_11__0000001
    static let obstacle                        : UInt32 = 0b100___000000000
        static let lethalObstacle              : UInt32 = 0b100_01__0000000
        static let nonLethalObstacle           : UInt32 = 0b100_10__0000000
    static let darkness                        : UInt32 = 0b011___000000001
}
