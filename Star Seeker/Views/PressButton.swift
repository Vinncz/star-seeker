import SpriteKit

class PressButtonNode : SKSpriteNode {
    
    var isAttached : Bool { return parent != nil || scene != nil }
    var command    : () -> Void = {}
    var completion : () -> Void = {}
    
    init ( name: String = "", imageNamed: String, command: @escaping () -> Void = {}, completion: @escaping () -> Void = {} ) {
        self.command = command
        self.completion = completion
        
        let texture = SKTexture(imageNamed: imageNamed)
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.name = name
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan (_ touches: Set<UITouch>, with event: UIEvent? ) {
        command()
    }
    
    override func touchesEnded ( _ touches: Set<UITouch>, with event: UIEvent? ) {
        completion()
    }
    
    /* Inherited from SKNode. Refrain from modifying the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
}
