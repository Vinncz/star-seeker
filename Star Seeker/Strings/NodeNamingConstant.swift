import Foundation

struct NodeNamingConstant {
    
    static let boundary    : String = "VERTEX.STAR_SEEKER.BOUNDARY_OBJECT"
    static let wrapper     : String = "VERTEX.STAR_SEEKER.WRAPPER_OBJECT"
    static let neoWrapper  : String = "VERTEX.STAR_SEEKER.NEO_WRAPPER_OBJECT"
    static let player      : String = "VERTEX.STAR_SEEKER.PLAYER_OBJECT"
    static let game        : String = "VERTEX.STAR_SEEKER.GAME_SCENE"
    
    struct Platform {
        static let platform        : String = "VERTEX.STAR_SEEKER.PLATFORM_OBJECT"
        static let inertPlatform   : String = "VERTEX.STAR_SEEKER.INERT.PLATFORM_OBJECT"
        static let dynamicPlatform : String = "VERTEX.STAR_SEEKER.DYNAMIC.PLATFORM_OBJECT"
    }
    
    struct Button {
        static let leftControl  : String = "VERTEX.STAR_SEEKER.CONTROLLER.LEFT_BUTTON"
        static let rightControl : String = "VERTEX.STAR_SEEKER.CONTROLLER.RIGHT_BUTTON"
        static let jumpControl  : String = "VERTEX.STAR_SEEKER.CONTROLLER.JUMP_BUTTON"
        static let climbControl : String = "VERTEX.STAR_SEEKER.CONTROLLER.CLIMB_BUTTON"
    }
    
}
