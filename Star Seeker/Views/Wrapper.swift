import SpriteKit

class Wrapper : SKNode {
    
    enum Direction {
        case horizontal
        case vertical
        case horizontalFlipped
        case verticalFlipped
    }
    
    var totalWidth  : CGFloat = 0
    var totalHeight : CGFloat = 0
    var direction   : Direction
    var spacing     : CGFloat {
        didSet {
            updateChildPositions()
        }
    }
    
    init ( name: String = "", spacing: CGFloat, direction: Direction ) {
        self.spacing   = spacing
        self.direction = direction
        super.init()
        self.name = name
    }

    func addSpacedChild ( _ node: SKNode ) {
        let isFirstNode = children.isEmpty
        node.position = calculatePosition(node: node, isFirstNode: isFirstNode)
        addChild(node)
    }
    
    private func updateChildPositions () {
        reset()
        for (index, node) in children.enumerated() {
            node.position = calculatePosition(node: node, isFirstNode: index == 0)
        }
    }
    
    private func calculatePosition ( node: SKNode, isFirstNode: Bool ) -> CGPoint {
        let nodeWidth  = node.frame.width
        let nodeHeight = node.frame.height
        var position   : CGPoint
        
        switch direction {
            case .horizontal:
                let x = isFirstNode ? totalWidth + nodeWidth / 2 : totalWidth + nodeWidth / 2 + spacing
                let y = nodeHeight / 2
                position = CGPoint(x: x, y: y)
                totalWidth += nodeWidth + (isFirstNode ? 0 : spacing)
                
            case .vertical:
                let x = nodeWidth / 2
                let y = isFirstNode ? -totalHeight - nodeHeight / 2 : -totalHeight - nodeHeight / 2 - spacing
                position = CGPoint(x: x, y: y)
                totalHeight += nodeHeight + (isFirstNode ? 0 : spacing)
                
            case .horizontalFlipped:
                let x = isFirstNode ? -totalWidth - nodeWidth / 2 : -totalWidth - nodeWidth / 2 - spacing
                let y = nodeHeight / 2
                position = CGPoint(x: x, y: y)
                totalWidth += nodeWidth + (isFirstNode ? 0 : spacing)
                
            case .verticalFlipped:
                let x = nodeWidth / 2
                let y = isFirstNode ? totalHeight + nodeHeight / 2 : totalHeight + nodeHeight / 2 + spacing
                position = CGPoint(x: x, y: y)
                totalHeight += nodeHeight + (isFirstNode ? 0 : spacing)
        }
        
        return position
    }
    
    private func reset () {
        totalWidth  = 0
        totalHeight = 0
    }
    
    /* Inherited from SKNode. Refrain from modifying the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
}
