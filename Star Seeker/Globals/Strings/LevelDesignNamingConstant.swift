import Foundation

struct LevelDesignConstant {
    struct Naming {
        /// "leveldesign."
        static let prefix = "leveldesign."
        
        struct Seasonal {
            /// "seasonal."
            static let seasonal    = "seasonal."
            /// "nonseasonal."
            static let nonseasonal = "nonseasonal."
        }
    }
    
    struct LevelRange {
        static let autumn : ClosedRange<Int> = 1...10
        static let winter : ClosedRange<Int> = 1...8
        static let spring : ClosedRange<Int> = 1...7
        static let summer : ClosedRange<Int> = 1...8
    }
}
