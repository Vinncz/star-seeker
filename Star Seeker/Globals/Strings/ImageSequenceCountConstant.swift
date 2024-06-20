import Foundation

struct ImageSequenceCountConstant {
    struct Player {
        static let climbing  : ClosedRange<Int> = 0...10
        static let jumping   : ClosedRange<Int> = 0...19
        static let idle      : ClosedRange<Int> = 0...30
        static let squatting : ClosedRange<Int> = 0...10
        static let moving    : ClosedRange<Int> = 0...19
    }
    static let darkness : ClosedRange<Int> = 0...59
}
