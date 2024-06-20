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
        static let platform = "platform"
        
        struct Inert {
            static let name : String = "platform.inert"
            static let base : String = "platform.inert.base"
            
            struct Autumn {
                static let base : String = "platform.inert.autumn.base"
                static let wall : String = "platform.inert.autumn.wall"
            }
            
            struct Dynamic {
                static let dynamic : String = "platform.inert.dynamic"
                
                static let collapsible : String = "platform.inert.dynamic.collapsible"
                static let moving : String = "platform.inert.dynamic.moving"
            }
        }
        
        struct Reactive {
            static let name : String = "platform.reactive"
            
            struct Autumn {
                static let splippery : String = "platform.reactive.autumn.slippery"
                static let sticky : String = "platform.reactive.autumn.sticky"
            }
            
            struct Placeholder {
                static let slippery : String = "platform.reactive.slippery"
                static let sticky   : String = "platform.reactive.sticky"
            }
        }
        
        struct PassThrough {
            static let name : String = "platform.passthrough"
            
            struct Autumn {
                static let climbable : String = "platform.passthrough.autumn.climbable"
            }
            
            struct Placeholder {
                static let climbable : String = "platform.passthrough.climbable"
            }
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
    }
    
}
