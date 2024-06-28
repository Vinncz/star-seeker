import SpriteKit

extension SKAction {
    func withTimingModeOf ( _ timingMode: SKActionTimingMode ) -> Self {
        self.timingMode = timingMode
        return self
    }
}
