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
