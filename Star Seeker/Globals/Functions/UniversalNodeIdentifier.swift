import SpriteKit

struct UniversalNodeIdentifier {
    static func identify ( types: [Any.Type], _ bodyA: SKNode, _ bodyB: SKNode ) -> [SKNode?] {
        var nodes: [SKNode?] = [nil, nil]
                
        for (index, type) in types.enumerated() {
            if type == Player.self, let node = (bodyA as? Player) ?? (bodyB as? Player) {
                nodes[index] = node
            } else if type == Platform.self, let node = (bodyA as? Platform) ?? (bodyB as? Platform) {
                nodes[index] = node
            }
        }
        
        return nodes
    }
}
