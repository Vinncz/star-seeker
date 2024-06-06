import SpriteKit

class PressButtonNode : SKSpriteNode {
    
    var isAttached : Bool { return parent != nil || scene != nil }
    var command    : () -> Void = {}
    
    init ( name: String = "", imageNamed: String, command: @escaping () -> Void = {} ) {
        self.command = command
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: .clear, size: texture.size())
        self.name = name
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan (_ touches: Set<UITouch>, with event: UIEvent?) {
        command()
    }
    
    /* Inherited from SKNode. Refrain from modifying the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
}
