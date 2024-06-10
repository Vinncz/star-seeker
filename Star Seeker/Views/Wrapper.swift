import SpriteKit

/** DEPRECATED */
class Wrapper : SKNode {
    
    enum Direction {
        case horizontal
        case vertical
        case horizontalFlipped
        case verticalFlipped
    }
    
    var totalWidth  : CGFloat = 0
    var totalHeight : CGFloat = 0
    private let boundary = SKShapeNode()
    var direction   : Direction
    var size        : CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0

        for node in children {
            let nodeWidth = node.frame.width
            let nodeHeight = node.frame.height
            switch direction {
            case .horizontal, .horizontalFlipped:
                width += nodeWidth + (node === children.first ? 0 : spacing)
                height = max(height, nodeHeight)
            case .vertical, .verticalFlipped:
                height += nodeHeight + (node === children.first ? 0 : spacing)
                width = max(width, nodeWidth)
            }
        }
        
        return CGSize(width: width, height: height)
    }
    var spacing     : CGFloat {
        didSet {
            updateChildPositions()
        }
    }
    
    private func updateBoundary() {
        let size = self.size
        boundary.path = CGPath(rect: CGRect(origin: .zero, size: size), transform: nil)
        boundary.position = CGPoint(x: -size.width / 2, y: -size.height / 2)
    }
    
    init ( name: String = "", spacing: CGFloat, direction: Direction ) {
        self.spacing   = spacing
        self.direction = direction
        super.init()
        self.name = name
        addChild(boundary)
    }

    func addSpacedChild ( _ node: SKNode ) {
        let isFirstNode = children.isEmpty
        node.position = calculatePosition(node: node, isFirstNode: isFirstNode)
        addChild(node)
        updateBoundary()
    }
    
    private func updateChildPositions () {
        reset()
        for (index, node) in children.enumerated() {
            node.position = calculatePosition(node: node, isFirstNode: index == 0)
        }
    }
    
    private func calculatePosition(node: SKNode, isFirstNode: Bool) -> CGPoint {
        let nodeWidth = node is Wrapper ? (node as! Wrapper).size.width : node.frame.width
        let nodeHeight = node is Wrapper ? (node as! Wrapper).size.height : node.frame.height
        
        var position: CGPoint
        switch direction {
        case .horizontal, .horizontalFlipped:
            let x = isFirstNode ? totalWidth - nodeWidth / 2 : totalWidth + spacing - nodeWidth / 2
            position = CGPoint(x: x, y: 0)
            totalWidth += nodeWidth + (isFirstNode ? 0 : spacing)
        case .vertical, .verticalFlipped:
            let y = isFirstNode ? -totalHeight + nodeHeight / 2 : -totalHeight - spacing + nodeHeight / 2
            position = CGPoint(x: 0, y: y)
            totalHeight += nodeHeight + (isFirstNode ? 0 : spacing)
        }
        return position
    }

    func layout() {
        var isFirstNode = true
        for node in children {
            node.position = calculatePosition(node: node, isFirstNode: isFirstNode)
            isFirstNode = false
        }

        // Adjust positions based on total width and height
        let dx = totalWidth / 2
        let dy = totalHeight / 2
        for node in children {
            node.position = CGPoint(x: node.position.x - dx, y: node.position.y - dy)
        }
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
