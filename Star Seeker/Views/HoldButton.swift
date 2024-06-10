import SpriteKit

class HoldButtonNode : SKSpriteNode {
    
    var isAttached : Bool { return parent != nil || scene != nil }
    var isPressed  : Bool = false
    var command    : () -> Void = {}
    var completion : () -> Void = {}
    var timer      : Timer?
    
    init ( name: String = "", imageNamed: String, command: @escaping () -> Void = {}, completion: @escaping () -> Void = {} ) {
        self.command    = command
        self.completion = completion
        
        let texture = SKTexture(imageNamed: imageNamed)
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.name = name
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan ( _ touches: Set<UITouch>, with event: UIEvent? ) {
        isPressed = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.command()
        }
    }

    override func touchesEnded ( _ touches: Set<UITouch>, with event: UIEvent? ) {
        isPressed = false
        timer?.invalidate()
        timer = nil
        
        completion()
    }
    
    
    /* Inherited from SKNode. Refrain from modifying the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
}
