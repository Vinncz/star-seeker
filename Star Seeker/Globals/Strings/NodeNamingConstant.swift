import Foundation

struct NodeNamingConstant {
    
    static let any              : String = "VERTEX.STAR_SEEKER.NODE.UNIDENTIFIED.OBJECT"
    static let boundary         : String = "VERTEX.STAR_SEEKER.NODE.BOUNDARY.OBJECT"
    static let wrapper          : String = "VERTEX.STAR_SEEKER.NODE.WRAPPER.OBJECT"
    static let neoWrapper       : String = "VERTEX.STAR_SEEKER.NODE.NEO_WRAPPER.OBJECT"
    static let player           : String = "VERTEX.STAR_SEEKER.NODE.PLAYER.OBJECT"
    static let game             : String = "VERTEX.STAR_SEEKER.NODE.GAME_SCENE.OBJECT"
    static let movementControls : String = "VERTEX.STAR_SEEKER.NODE.MOVEMENT_CONTROLS.OBJECT"
    static let darkness         : String = "VERTEX.STAR_SEEKER.NODE.DARKNESS.OBJECT"
    static let outboundIndicator: String = "VERTEX.STAR_SEEKER.NODE.OUTBOUND_INDICATOR.OBJECT"
    
    struct Platform {
        static let platform : String = "VERTEX.STAR_SEEKER.NODE.PLATFORM.OBJECT"
        
        struct Inert {
            static let name : String = "VERTEX.STAR_SEEKER.NODE.PLATFORM.INERT.OBJECT"
            static let base : String = "VERTEX.STAR_SEEKER.NODE.PLATFORM.INERT.BASE.OBJECT"
            
            struct Dynamic {
                static let name        : String = "VERTEX.STAR_SEEKER.NODE.PLATFORM.INERT.DYNAMIC.OBJECT"
                
                static let collapsible : String = "VERTEX.STAR_SEEKER.NODE.PLATFORM.INERT.DYNAMIC.COLLAPSIBLE.OBJECT"
                static let moving      : String = "VERTEX.STAR_SEEKER.NODE.PLATFORM.INERT.DYNAMIC.MOVING.OBJECT"
            }
        }
        
        struct Reactive {
            static let name     : String = "VERTEX.STAR_SEEKER.NODE.PLATFORM.REACTIVE.OBJECT"
            
            static let slippery : String = "VERTEX.STAR_SEEKER.NODE.PLATFORM.REACTIVE.SLIPPERY.OBJECT"
            static let sticky   : String = "VERTEX.STAR_SEEKER.NODE.PLATFORM.REACTIVE.STICKY.OBJECT"
        }
        
        struct PassThrough {
            static let name        : String = "VERTEX.STAR_SEEKER.NODE.PLATFORM.PASS_THROUGH.OBJECT"
            
            static let climbable   : String = "VERTEX.STAR_SEEKER.NODE.PLATFORM.PASS_THROUGH.CLIMBABLE.OBJECT"
            static let movingTrack : String = "VERTEX.STAR_SEEKER.NODE.PLATFORM.PASS_THROUGH.MOVING_TRACK.OBJECT"
        }
    }
    
    struct Button {
        static let leftControl  : String = "VERTEX.STAR_SEEKER.BUTTON.LEFT.OBJECT"
        static let rightControl : String = "VERTEX.STAR_SEEKER.BUTTON.RIGHT.OBJECT"
        static let jumpControl  : String = "VERTEX.STAR_SEEKER.BUTTON.JUMP.OBJECT"
        static let climbControl : String = "VERTEX.STAR_SEEKER.BUTTON.CLIMB.OBJECT"
    }
    
}
