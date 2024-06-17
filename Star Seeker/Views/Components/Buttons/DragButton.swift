import SpriteKit

class DragButtonNode : SKSpriteNode {
    
    var isAttached           : Bool { return parent != nil || scene != nil }
    var isPressed            : Bool = false
    
    var initialNodePosition  : CGPoint?
    var initialTouchPosition : CGPoint?
    var currentTouchPosition : CGPoint?
    var maxDraggableDistance : CGFloat = 100.0
    
    var command              : ((CGFloat, CGFloat) -> Void)?
    var completion           : ((CGFloat, CGFloat) -> Void)?
    
    var timer                : Timer?
    var updateInterval       : TimeInterval = 0.1
    
    init ( name: String = "", imageNamed: String, maxDraggableDistance: CGFloat = 100, updateInterval: TimeInterval = 0.1, command: ((CGFloat, CGFloat) -> Void)? = nil, completion: ((CGFloat, CGFloat) -> Void)? = nil ) {
        self.command              = command
        self.completion           = completion
        self.maxDraggableDistance = maxDraggableDistance
        
        let texture = SKTexture(imageNamed: imageNamed)
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.name = name
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan ( _ touches: Set<UITouch>, with event: UIEvent? ) {
        guard let touch = touches.first else { return }
        
        initialTouchPosition = touch.location(in: self)
        initialNodePosition = self.position
        currentTouchPosition = initialTouchPosition
        
        isPressed = true
    }
    
    override func touchesMoved ( _ touches: Set<UITouch>, with event: UIEvent? ) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self.parent!)
        updatePosition(location)
    }
    
    override func touchesEnded ( _ touches: Set<UITouch>, with event: UIEvent? ) {
        isPressed = false
        
        if let initialTouchPosition = self.initialTouchPosition, let touch = touches.first {
            let finalTouchPosition = touch.location(in: self.parent!)
            
            let deltaX = finalTouchPosition.x - initialTouchPosition.x
            let deltaY = finalTouchPosition.y - initialTouchPosition.y
            
            completion?(deltaX, deltaY)
        }
        
        resetTouchPositions()
    }
    
    private func updatePosition ( _ location: CGPoint ) {
        self.position             = calculateNewPosition(from: location)
        self.currentTouchPosition = self.position
        
        if let initialTouchPosition = self.initialTouchPosition, let currentTouchPosition = self.currentTouchPosition {
            let deltaX = currentTouchPosition.x - initialTouchPosition.x
            let deltaY = currentTouchPosition.y - initialTouchPosition.y
            
            command?(deltaX, deltaY)
        }
    }
        
    private func calculateNewPosition ( from location: CGPoint ) -> CGPoint {
        guard let initialNodePosition = self.initialNodePosition else {
            return location
        }
        
        let dx = location.x - initialNodePosition.x
        let dy = location.y - initialNodePosition.y
        let distance = sqrt(dx*dx + dy*dy)
        
        if ( distance > maxDraggableDistance ) {
            let directionX = dx / distance
            let directionY = dy / distance
            return CGPoint(x: initialNodePosition.x + directionX * maxDraggableDistance, y: initialNodePosition.y + directionY * maxDraggableDistance)
            
        } else {
            return location
            
        }
    }
    
    private func resetTouchPositions () {
        initialTouchPosition = nil
        currentTouchPosition = nil
        if let initialNodePosition = self.initialNodePosition {
            self.position = initialNodePosition
        }
    }
    
    
    /* Inherited from SKNode. Refrain from modifying the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
