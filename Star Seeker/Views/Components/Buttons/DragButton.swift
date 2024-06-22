import SpriteKit

class DragButtonNode : SKSpriteNode {
    var initialTouchPosition : CGPoint?
    var maxDraggableDistance : CGFloat = 100.0
    
    var onTouch              : (() -> Void)?
    var onTouchEnd           : (() -> Void)?
    var command              : ((CGFloat, CGFloat) -> Void)?
    var completion           : ((CGFloat, CGFloat) -> Void)?
    
    init ( name: String = "", imageNamed: String, maxDraggableDistance: CGFloat = 100, onTouch: (() -> Void)? = nil, onTouchEnd: (() -> Void)? = nil, command: ((CGFloat, CGFloat) -> Void)? = nil, completion: ((CGFloat, CGFloat) -> Void)? = nil ) {
        self.onTouch              = onTouch
        self.onTouchEnd           = onTouchEnd
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
        onTouch?()
    }
    
    override func touchesMoved ( _ touches: Set<UITouch>, with event: UIEvent? ) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self.parent!)
        updatePosition(location)
    }
    
    override func touchesEnded ( _ touches: Set<UITouch>, with event: UIEvent? ) {
        completion?(self.position.x, self.position.y)
        resetTouchPositions()
        onTouchEnd?()
    }
    
    private func updatePosition ( _ location: CGPoint ) {
        self.position             = calculateNewPosition(from: location)
        command?(self.position.x, self.position.y)
    }
    
    private func calculateNewPosition ( from location: CGPoint ) -> CGPoint {
        guard let initialTouchPosition = self.initialTouchPosition else {
            return location
        }
        
        let dx = location.x - initialTouchPosition.x
        let dy = location.y - initialTouchPosition.y
        let distance = CGPoint(x: dx, y: dy).getDistance()
        
        if ( distance > maxDraggableDistance ) {
            let directionX = dx / distance
            let directionY = dy / distance
            return CGPoint(x: directionX * maxDraggableDistance, y: directionY * maxDraggableDistance)
        } else {
            return CGPoint(x: dx , y: dy)
        }
    }
    
    private func resetTouchPositions () {
        initialTouchPosition = nil
        self.position = CGPoint(x: 0.0, y: 0.0)
    }
    
    
    /* Inherited from SKNode. Refrain from modifying the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
