import SpriteKit

/// A struct that helps to identify any instace of SKNode, and converts it into the appropriate concrete implementation of said node.
/// 
/// This struct does not support instanciation of itself. Every function contained within it are static. 
struct UniversalNodeIdentifier {
    
    private init () {}
    
    /// Static function which identifies which of the two bodies have the correct type, and return it in the correct order.
    /// 
    /// # Arguments
    /// ### • types: [Any.Type]
    /// An array of types, to which both bodyA and bodyB will be typecasted to. The typecast will be in order; meaning if you supply TypeA first followed by TypeB, the returned tuple's type will always follow said sequence. 
    /// ### • bodyA: SKNode
    /// An instance of SKNode which will be typecasted according to the supplied type array. Being body "A" doesn't guarantee that this argument will place first inside the returned tuple.
    /// ### • bodyB: SKNode
    /// An instance of SKNode which will be typecasted according to the supplied type array. Being body "B" doesn't guarantee that this argument will place last inside the returned tuple.
    /// 
    /// # Usage
    /// ```swift
    /// let nodes = UniversalNodeIdentifier.identify (
    ///     checks: [
    ///         { $0 as? Player } ,   // node[0] will always have the type of Player
    ///         { $0 as? Darkness }   // node[1] will always have the type of Darkness
    ///     ], 
    ///     contact.bodyA.node!, 
    ///     contact.bodyB.node!
    /// )
    /// if let player = nodes[0] as? Player, let platform = nodes[1] as? Darkness {
    ///     // typecast once, use it forever.
    /// }
    /// ```
    static func identify(checks: [(SKNode) -> SKNode?], _ bodyA: SKNode, _ bodyB: SKNode) -> [SKNode?] {
        var nodes: [SKNode?] = Array(repeating: nil, count: checks.count)

        let bodies = [bodyA, bodyB]
        for body in bodies {
            for (index, check) in checks.enumerated() {
                if nodes[index] == nil {
                    nodes[index] = check(body)
                }
            }
        }

        return nodes
    }
    
}
