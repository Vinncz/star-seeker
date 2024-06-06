import Foundation

protocol Sizable {
    static var nano   : Double { get set }
    static var micro  : Double { get set }
    static var mini   : Double { get set }
    static var normal : Double { get set }
    static var large  : Double { get set }
    static var huge   : Double { get set }
}

struct UIConfig {
    
    struct FontSizes : Sizable {
        /** Represents 16px on screen */
        static var nano   : Double = 16
        /** Represents 24px on screen */
        static var micro  : Double = 24
        /** Represents 36px on screen */
        static var mini   : Double = 36
        /** Represents 48px on screen */
        static var normal : Double = 48
        /** Represents 56px on screen */
        static var large  : Double = 56
        /** Represents 64px on screen */
        static var huge   : Double = 64
        /** Represents 72px on screen */
        static var giant  : Double = 72
    }
    
    struct SidebarSizes : Sizable {
        /** Represents 160px on screen */
        static var nano   : Double = 160
        /** Represents 192px on screen */
        static var micro  : Double = 192
        /** Represents 224px on screen */
        static var mini   : Double = 224
        /** Represents 256px on screen */
        static var normal : Double = 256
        /** Represents 320px on screen */
        static var large  : Double = 320
        /** Represents 384px on screen */
        static var huge   : Double = 384
    }
    
    struct SquareSizes : Sizable {
        /** Represents 16px on screen */
        static var nano   : Double = 16
        /** Represents 32px on screen */
        static var micro  : Double = 32
        /** Represents 64px on screen */
        static var mini   : Double = 64
        /** Represents 96px on screen */
        static var normal : Double = 96
        /** Represents 128px on screen */
        static var large  : Double = 128
        /** Represents 156px on screen */
        static var huge   : Double = 156
        /** Represents 256px on screen */
        static var giant  : Double = 256
    }
    
    struct CornerRadiuses : Sizable {
        /** Represents 2px on screen */
        static var nano   : Double = 2
        /** Represents 4px on screen */
        static var micro  : Double = 4
        /** Represents 6px on screen */
        static var mini   : Double = 6
        /** Represents 8px on screen */
        static var normal : Double = 8
        /** Represents 12px on screen */
        static var large  : Double = 12
        /** Represents 24px on screen */
        static var huge   : Double = 24
    }
    
    struct Spacings : Sizable {
        /** Represents 1px on screen */
        static var nano   : Double = 1
        /** Represents 2px on screen */
        static var micro  : Double = 2
        /** Represents 4px on screen */
        static var mini   : Double = 4
        /** Represents 8px on screen */
        static var normal : Double = 8
        /** Represents 16px on screen */
        static var large  : Double = 16
        /** Represents 32px on screen */
        static var huge   : Double = 32
    }
    
    struct Paddings : Sizable {
        /** Represents 2px on screen */
        static var nano   : Double = 2
        /** Represents 4px on screen */
        static var micro  : Double = 4
        /** Represents 6px on screen */
        static var mini   : Double = 6
        /** Represents 8px on screen */
        static var normal : Double = 8
        /** Represents 12px on screen */
        static var large  : Double = 12
        /** Represents 24px on screen */
        static var huge   : Double = 24
    }
    
}
