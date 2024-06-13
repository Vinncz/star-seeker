import SpriteKit

class DragButtonNode : SKSpriteNode {
    
    var isAttached           : Bool { return parent != nil || scene != nil }
    var isPressed            : Bool = false
    
    var initialNodePosition  : CGPoint?
    var initialTouchPosition : CGPoint?
    var currentTouchPosition : CGPoint?
    
    var command              : ((CGFloat, CGFloat) -> Void)?
    var completion           : ((CGFloat, CGFloat) -> Void)?
    
    var timer                : Timer?
    var updateInterval       : TimeInterval = 0.1
    
    init ( name: String = "", imageNamed: String, updateInterval: TimeInterval = 0.1, command: ((CGFloat, CGFloat) -> Void)? = nil, completion: ((CGFloat, CGFloat) -> Void)? = nil ) {
        self.command    = command
        self.completion = completion
        
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
        self.position = location
        currentTouchPosition = location
        if let initialTouchPosition = self.initialTouchPosition, let currentTouchPosition = self.currentTouchPosition {
            let deltaX = currentTouchPosition.x - initialTouchPosition.x
            let deltaY = currentTouchPosition.y - initialTouchPosition.y
            command?(deltaX, deltaY)
        }
    }
    
    override func touchesEnded ( _ touches: Set<UITouch>, with event: UIEvent? ) {
        isPressed = false
        
        if let initialTouchPosition = self.initialTouchPosition,
           let touch = touches.first {
            let finalTouchPosition = touch.location(in: self.parent!)
            let deltaX = finalTouchPosition.x - initialTouchPosition.x
            let deltaY = finalTouchPosition.y - initialTouchPosition.y
            completion?(deltaX, deltaY)
        }
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
