import SpriteKit

extension SKNode: HoldsAction {
    
    /// Since extensions cannot set stored attribute to the class it extends, 
    ///     we use obj-c runtime function to associate a value to an instance of SKNode.
    /// The attribute isn't part of the isntance as in one sheet of paper,
    ///     but it is clipped-in by obj-c runtime function.
    private struct AssociatedKeys {
        static var actionPool : UInt8 = 0
    }

    var actionPool: [String : SKAction] {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.actionPool) as? [String : SKAction] ?? [:]
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.actionPool, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Performs an SKAction from self actionPool. 
    /// Should the supplied name does not match any of the actions present, no action will be performed.
    func playAction ( named key: String, completion: @escaping () -> Void = {} ) -> Void {
        guard let action = actionPool[key] else {
            return
        }
        self.run(action, completion: completion)
    }    
    
    
    /// Stops an SKAction from self actionPool. 
    /// Should the supplied name does not match any of the actions present, no action will be performed.
    func stopAction ( named key: String ) -> Void {
        guard let _ = actionPool[key] else {
            return
        }
        self.removeAction(forKey: key)
    }
    
    /// Calculates the maximum boundary of self, by measuring their children position relative to self (0, 0)
    func calculateSize () -> CGSize {
        var minX: CGFloat = CGFloat.infinity
        var minY: CGFloat = CGFloat.infinity
        var maxX: CGFloat = -CGFloat.infinity
        var maxY: CGFloat = -CGFloat.infinity

        for child in self.children {
            let frame = child.frame
            minX = min(minX, frame.minX)
            minY = min(minY, frame.minY)
            maxX = max(maxX, frame.maxX)
            maxY = max(maxY, frame.maxY)
        }

        return CGSize (
            width: maxX - minX, 
            height: maxY - minY
        )
    }
    
    func withPositionOf ( pos: CGPoint ) -> Self {
        self.position = pos
        return self
    }
    
}
