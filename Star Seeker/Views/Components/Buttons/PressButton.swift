import SpriteKit

class PressButtonNode : SKSpriteNode {
    
    var isAttached : Bool { return parent != nil || scene != nil }
    var command    : () -> Void = {}
    var completion : () -> Void = {}
    
    var maxPressedCount : Int = Int.max
    var resetInterval   : TimeInterval = 0
    var pressCount      : Int = 0
    var lastPressTime   = Date().timeIntervalSince1970
    
    init ( name: String = "", imageNamed: String, maxPressedCount: Int = Int.max, timeIntervalToReset: TimeInterval = 0, command: @escaping () -> Void = {}, completion: @escaping () -> Void = {} ) {
        self.command = command
        self.completion = completion
        self.maxPressedCount = maxPressedCount
        self.resetInterval = timeIntervalToReset
        
        let texture = SKTexture(imageNamed: imageNamed)
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.name = name
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan ( _ touches: Set<UITouch>, with event: UIEvent? ) {
        let currentTime = Date().timeIntervalSince1970
        if ( pressCount < self.maxPressedCount || currentTime - self.lastPressTime > resetInterval ) {
            pressCount = pressCount < 2 ? pressCount + 1 : 1
            lastPressTime = currentTime
            command()
            completion()
        }
    }
    
    /* Inherited from SKNode. Refrain from modifying the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
}
