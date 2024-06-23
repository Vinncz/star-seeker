import Foundation

struct ImageNamingConstant {
    
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
    
    struct Platform {
        static let prefix = "platform."
        
        struct Seasonal {
            static let nonseasonal : String = "nonseasonal."
            static let seasonal    : String = "seasonal."
        }
        
        struct Inert {
            static let prefix : String = "inert."
            
            static let base   : String = "base"
            static let wall   : String = "wall"
            
            struct Dynamic {
                static let prefix      : String = "dynamic."
                
                static let collapsible : String = "collapsible"
                static let moving      : String = "moving"
            }
        }
        
        struct Reactive {
            static let prefix   : String = "reactive."
            
            static let slippery : String = "slippery"
            static let sticky   : String = "sticky"
        }
        
        struct PassThrough {
            static let prefix : String = "passthrough."
            
            static let climbable : String = "climbable"
        }
    }
    
    struct Button {
        static let climb : String = "button.climb"
        static let jump  : String = "button.jump"
        static let left  : String = "button.left"
        static let right : String = "button.right"
        static let up    : String = "button.up"
    }
    
    struct Interface {
        struct Button {
            static let pause    : String = "interface.button.pause"
            static let play     : String = "interface.button.play"
            static let exit     : String = "interface.button.exit"
            static let restart  : String = "interface.button.restart"
        }
        
        static let box          : String = "interface.box"
        static let outboundIndicator: String = "interface.outbound-indicator"
        static let startTitle: String = "interface.start-title"
        
        struct Joystick {
            static let top      : String = "interface.joystick.top"
            static let bottom   : String = "interface.joystick.bottom"
            static let arrow    : String = "interface.joystick.drag-indicator"
        }
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
    }
    
}
