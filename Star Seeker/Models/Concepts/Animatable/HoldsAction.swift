import SpriteKit

protocol HoldsAction {
    
    /// Stores a pair of String-SKAction to be retrieved and performed later by the SKNode.
    var actionPool : [String: SKAction] { get set }
    
    
    /// Performs an SKAction from the SKNode's actionPool. 
    /// Should the supplied name does not match any of the actions present, no action will be performed.
    func playAction ( named key: String, completion: @escaping () -> Void ) -> Void    
    
    
    /// Stops an SKAction from the SKNode's actionPool. 
    /// Should the supplied name does not match any of the actions present, no action will be performed.
    func stopAction ( named key: String ) -> Void
    
}
