import SpriteKit

class NeoWrapper : SKNode, Sizeable {
    
    var totalWidth  : CGFloat = 0
    var totalHeight : CGFloat = 0

    let boundary    : SKShapeNode
    var direction   : Direction
        
    var size        : CGSize {
        return CGSize(width: totalWidth, height: totalHeight)
    }
    var spacing     : CGFloat {
        didSet { updateChildPositions() }
    }
    
    init ( spacing: CGFloat, direction: Direction, boundaryIsVisible: Bool = false ) {
        self.boundary = NeoWrapper.makeBoundary( visibility: boundaryIsVisible )
        
        self.spacing   = spacing
        self.direction = direction
        
        super.init()
        
        self.name = NodeNamingConstant.neoWrapper
        
        addChild(boundary)
        updateBoundary()
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/** Extension which adds direction functionality */
extension NeoWrapper {
    
    /** Set of directions which dictates where will the children nodes be stacked to */
    enum Direction {
        /** Dictates for the children nodes to be stacked from left to right */
        case horizontal
        /** Dictates for the children nodes to be stacked from right to left */
        case horizontalFlipped
        /** Dictates for the children nodes to be stacked from top to bottom */
        case vertical
        /** Dictates for the children nodes to be stacked from bottom to top */
        case verticalFlipped
    }
    
}

/** Extension which handles object placement */
extension NeoWrapper {
    
    /** Inserts the provided node into the wrapper's children tree */
    func addSpacedChild ( _ node: SKNode ) {
        let isFirstNode : Bool = children.count < 2 && children.first?.name == NodeNamingConstant.boundary
        debug("recieved node is first child: \(isFirstNode)")
        node.position = calculatePosition(node: node, isFirstNode: isFirstNode)
        
        addChild(node)
        updateBoundary()
    }
    
    /// Calculates where should a node be placed inside self. 
    /// It returns a CGPoint instance, which marks a point relative to self's (0, 0). 
    /// 
    /// This method provides the correct position for a node placement; 
    ///     after compensating for self's spacing and each child's width.
    ///     
    /// The calculation logic is as follows:
    /// - Self only have **one children**: Its own boundary:
    ///   
    ///   Since there are no spacings nor other children to be accounted, this method will always return (0, 0).
    ///   
    /// - Self have **two children**: Its own boundary and one other node:
    /// 
    ///   This method will factor the following:
    ///   - the existing child's width, 
    ///   - self's spacing value
    ///   
    ///   It adds the two together, and returns it as CGPoint object.
    ///   
    ///   ```
    ///   ⬜⬜⬜⬜⬜⬜                 ⬜⬜⬜⬜⬜⬜
    ///   |--  50px  --|   |-- 16px --|  ⬆ Returned Position
    ///   ```
    /// 
    ///   Picture the children with 50px width, and spacing of 16px. 
    ///   
    ///   The resulting position of the placement of a new node will be ``50 + 16 = 66`` pixels rightward relative to (0, 0) -- or simply (66, 0)
    ///   
    /// - Self have **two or more children**: Its own boundary and some other nodes:
    /// 
    ///   The logic will follow the ``two children``'s, yet it also factors any subsequent node's width and spacings which exists before the new node's position.
    ///    
    private func calculatePosition ( node: SKNode, isFirstNode: Bool ) -> CGPoint {
        let position : CGPoint
        let nodeWidth  : Double
        let nodeHeight : Double
        
        if ( node is Sizeable ) {
            nodeWidth  = (node as! Sizeable).size.width
            nodeHeight = (node as! Sizeable).size.height
            
        } else {
            let nodeSize = node.calculateSize()
            
            nodeWidth  = nodeSize.width
            nodeHeight = nodeSize.height
            
        }
        
        debug("recieved node: \(self.name ?? NodeNamingConstant.neoWrapper) w: \(nodeWidth) h: \(nodeHeight)")
        
        switch ( self.direction ) {
            case .horizontal, .horizontalFlipped:
                let x = totalWidth + (isFirstNode ? 0 : spacing)
                position = CGPoint(x: x, y: 0)
                
                totalWidth += nodeWidth + (isFirstNode ? 0 : spacing)
                totalHeight = max(totalHeight, nodeHeight)
                
                break
            
            case .vertical, .verticalFlipped:
                let y = totalHeight + (isFirstNode ? 0 : spacing)
                position = CGPoint(x: 0, y: y)
                
                totalWidth = max(totalWidth, nodeWidth)
                totalHeight += nodeHeight + (isFirstNode ? 0 : spacing)
                
                break
        }
        
        debug("spawn position for said node: \(position)")
        return position
    }
    
    /** Adjusts the spacing between children, should the spacing of self change */
    private func updateChildPositions () {
        NeoWrapper.resetDimention(of: self)
        
        for (index, node) in children.enumerated() {
            node.position = calculatePosition(node: node, isFirstNode: index == 1)
        }
    }
    
}

/** Extension which handles everything related to boundary */
extension NeoWrapper {
    
    /** Instanciates an SKShapeNode object with a predetermined attributes. For initializer's use. */
    private static func makeBoundary ( visibility: Bool ) -> SKShapeNode {
        let bound = SKShapeNode()
        bound.name = NodeNamingConstant.boundary
        bound.strokeColor = .clear
        
        if ( visibility ) {
            bound.strokeColor = .red.withAlphaComponent(0.5)
        }
        
        return bound
    }
    
    /** Prompts the recalculation of self's boundary size, to match the overall size of the nodes contained within */
    private func updateBoundary () {
        let size = self.size
        
        self.boundary.path     = CGPath(rect: CGRect(origin: .zero, size: size), transform: nil)
        self.boundary.position = CGPoint(x: -size.width / 2, y: -size.height / 2)
    }
    
}

/** Extension which helps in resetting statistics */
extension NeoWrapper {
    
    static func resetDimention ( of: NeoWrapper ) {
        of.totalWidth  = 0
        of.totalHeight = 0
    }
    
}
