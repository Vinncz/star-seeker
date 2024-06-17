import SpriteKit

class MovementController : SKNode {
    
    /** Reference to an instance of SKNode, which will be controlled by self */
    var target : Player
    
    init ( controls target : Player ) {
        self.target = target
        super.init()
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
