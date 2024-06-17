import Foundation

struct ImageNamingConstant {
    
    struct Season {
        static let autumn : String = ".Seautumn"
        static let winter : String = ".winter"
        static let spring : String = ".spring"
        static let summer : String = ".summer"
    }
    
    static let darkness : String = "darkness."
    
    struct Platform {
        static let platform = "platform"
        
        struct Inert {
            static let inert : String = "platform.inert"
            static let base  : String = "platform.inert.base"
            
            struct Dynamic {
                static let dynamic     : String = "platform.inert.dynamic"
                
                static let collapsible : String = "platform.inert.dynamic.collapsible"
                static let moving      : String = "platform.inert.dynamic.moving"
            }
        }
        
        struct Reactive {
            static let reactive : String = "platform.reactive"
            static let slippery : String = "platform.reactive.slippery"
            static let sticky   : String = "platform.reactive.sticky"
        }
        
        struct PassThrough {
            static let passThrough : String = "platform.passthrough"
            static let climbable   : String = "platform.passthrough.climbable"
        }
        
    }
    
    struct Button {
        static let climb : String = "button.climb"
        static let jump  : String = "button.jump"
        static let left  : String = "button.left"
        static let right : String = "button.right"
        static let up    : String = "button.up"
    }
    
    struct Player {
        struct Idle {
            struct Left {
                static let name : String = "player.idle.left."
            }
            struct Right {
                static let name : String = "player.idle.right."
            }
        }
        
        struct Moving {
            struct Left {
                static let name : String = "player.moving.left."
            }
            struct Right {
                static let name : String = "player.moving.right."
            }
        }
        
        struct Squating {
            static let name : String = "player.squat."
        }
        
        struct Jumping {
            struct Left {
                static let name : String = "player.jumping.left."
            }
            struct Right {
                static let name : String = "player.jumping.right."
            } 
        }
        
        struct Climbing {
            static let name : String = "player.climbing."
        }
        
        /* Legacy support */
        static let idleLeft  : String = "player.idle.left"
        static let idleRight : String = "player.idle.right"
        static let climbing  : String = "player.idle.climb"
    }
    
}
