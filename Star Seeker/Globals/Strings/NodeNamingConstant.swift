import Foundation

struct NodeNamingConstant {
    
    static let any        : String = "VERTEX.STAR_SEEKER.UNIDENTIFIED.OBJECT"
    static let boundary   : String = "VERTEX.STAR_SEEKER.BOUNDARY.OBJECT"
    static let wrapper    : String = "VERTEX.STAR_SEEKER.WRAPPER.OBJECT"
    static let neoWrapper : String = "VERTEX.STAR_SEEKER.NEO_WRAPPER.OBJECT"
    static let player     : String = "VERTEX.STAR_SEEKER.PLAYER.OBJECT"
    static let game       : String = "VERTEX.STAR_SEEKER.GAME_SCENE.OBJECT"
    
    struct Platform {
        static let platform : String = "VERTEX.STAR_SEEKER.PLATFORM.OBJECT"
        
        struct Inert {
            static let name : String = "VERTEX.STAR_SEEKER.PLATFORM.INERT.OBJECT"
            static let base : String = "VERTEX.STAR_SEEKER.PLATFORM.INERT.BASE.OBJECT"
            
            struct Dynamic {
                static let name        : String = "VERTEX.STAR_SEEKER.PLATFORM.INERT.DYNAMIC.OBJECT"
                
                static let collapsible : String = "VERTEX.STAR_SEEKER.PLATFORM.INERT.DYNAMIC.COLLAPSIBLE.OBJECT"
                static let moving      : String = "VERTEX.STAR_SEEKER.PLATFORM.INERT.DYNAMIC.MOVING.OBJECT"
            }
        }
        
        struct Reactive {
            static let name     : String = "VERTEX.STAR_SEEKER.PLATFORM.REACTIVE.OBJECT"
            
            static let slippery : String = "VERTEX.STAR_SEEKER.PLATFORM.REACTIVE.SLIPPERY.OBJECT"
            static let sticky   : String = "VERTEX.STAR_SEEKER.PLATFORM.REACTIVE.STICKY.OBJECT"
        }
        
        struct PassThrough {
            static let name      : String = "VERTEX.STAR_SEEKER.PLATFORM.PASS_THROUGH.OBJECT"
            
            static let climbable : String = "VERTEX.STAR_SEEKER.PLATFORM.PASS_THROUGH.CLIMBABLE.OBJECT"
        }
    }
    
    struct Button {
        static let leftControl  : String = "VERTEX.STAR_SEEKER.CONTROLLER.LEFT_BUTTON"
        static let rightControl : String = "VERTEX.STAR_SEEKER.CONTROLLER.RIGHT_BUTTON"
        static let jumpControl  : String = "VERTEX.STAR_SEEKER.CONTROLLER.JUMP_BUTTON"
        static let climbControl : String = "VERTEX.STAR_SEEKER.CONTROLLER.CLIMB_BUTTON"
    }
    
}

enum NodeCategory : String {
    
    case any             = "VERTEX.STAR_SEEKER.UNIDENTIFIED_OBJECT"
    case boundary        = "VERTEX.STAR_SEEKER.BOUNDARY_OBJECT"
    case player          = "VERTEX.STAR_SEEKER.PLAYER_OBJECT"
    
    case platform                    = "VERTEX.STAR_SEEKER.PLATFORM.OBJECT"
        case inertPlatform           = "VERTEX.STAR_SEEKER.INERT.PLATFORM_OBJECT"
            case basePlatform        = "VERTEX.STAR_SEEKER.BASE.PLATFORM_OBJECT"
        case dynamicPlatform         = "VERTEX.STAR_SEEKER.DYNAMIC.PLATFORM_OBJECT"
            case movingPlatform      = "VERTEX.STAR_SEEKER.MOVING.PLATFORM_OBJECT"
            case collapsiblePlatform = "VERTEX.STAR_SEEKER.COLLAPSIBLE.PLATFORM_OBJECT"
        case passThroughPlatform     = "VERTEX.STAR_SEEKER.PASS_THROUGH.PLATFORM_OBJECT"
            case climbablePlatform   = "VERTEX.STAR_SEEKER.CLIMBABLE.PLATFORM_OBJECT"
    
    var bitMask : UInt32 {
        switch self {
            case .player:
                return              0b0000000001
            case .platform:
                return              0b0000000010
                case .inertPlatform:
                    return          0b0000000100
                    case .basePlatform:
                        return      0b0000001000
                case .dynamicPlatform:
                    return          0b0000010000
                    case .movingPlatform:
                        return      0b0000100000
                    case .collapsiblePlatform:
                        return      0b0001000000
                case .passThroughPlatform:
                    return          0b0010000000
                    case .climbablePlatform:
                        return      0b0100000000
            case .boundary:
                return              0b01000000000
            default:
                return              0b00000000000
        }
    }
    
}
