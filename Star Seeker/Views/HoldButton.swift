import SpriteKit

class HoldButtonNode : SKSpriteNode {
    
    var isAttached : Bool { return parent != nil || scene != nil }
    var isPressed  : Bool = false
    var command    : () -> Void = {}
    var timer      : Timer?
    
    init ( name: String = "", imageNamed: String, command: @escaping () -> Void = {} ) {
        self.command = command
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
    }
    
    
    /* Inherited from SKNode. Refrain from modifying the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
}
