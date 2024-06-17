import CoreGraphics

extension CGSize {
    init ( rectOf: CGFloat ) {
        self.init(width: rectOf, height: rectOf)
    }
}
