import Foundation

struct ImageNamingConstant {
    
    struct Season {
        static let autumn : String = ".autumn"
        static let winter : String = ".winter"
        static let spring : String = ".spring"
        static let summer : String = ".summer"
    }
    
    static let darkness : String = "darkness."
    
    struct Background {
        struct Winter {
            static let background : String = "background.winter.background"
            static let overlay    : String = "background.winter.overlay"
        }
        struct Spring {
            static let background : String = "background.spring.background"
            static let overlay    : String = "background.spring.overlay"
        }
        struct Autumn {
            static let background : String = "background.autumn.background"
            static let overlay    : String = "background.autumn.overlay"
        }
    }
    
    struct Interface {
        struct Button {
            static let pause    : String = "interface.button.pause"
            static let play     : String = "interface.button.play"
            static let exit     : String = "interface.button.exit"
            static let restart  : String = "interface.button.restart"
        }
        
        static let box          : String = "interface.box"
        
        struct Joystick {
            static let top      : String = "interface.joystick.top"
            static let bottom   : String = "interface.joystick.bottom"
            static let arrow    : String = "interface.joystick.drag-indicator"
        }
    }
    
    struct Platform {
        static let platform = "platform"
        
        struct Inert {
            static let inert : String = "platform.inert"
            static let base  : String = "platform.inert.base"
            
            struct Autumn {
                static let base : String = "platform.inert.autumn.base"
                static let wall : String = "platform.inert.autumn.wall"
            }
            
            struct Dynamic {
                static let dynamic     : String = "platform.inert.dynamic"
                
                static let collapsible : String = "platform.inert.dynamic.collapsible"
                static let moving      : String = "platform.inert.dynamic.moving"
            }
        }
        
        struct Reactive {
            static let reactive : String = "platform.reactive"
            
            struct Autumn {
                static let splippery : String = "platform.reactive.autumn.slippery"
                static let sticky : String = "platform.reactive.autumn.sticky"
            }
            
            static let slippery : String = "platform.reactive.slippery"
            static let sticky   : String = "platform.reactive.sticky"
        }
        
        struct PassThrough {
            static let passThrough : String = "platform.passthrough"
            
            struct Autumn {
                static let climbable : String = "platform.passthrough.autumn.climbable"
            }
            
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
