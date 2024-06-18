import SpriteKit

class Darkness : SKSpriteNode {
    
    init (
        texture: SKTexture = SKTexture( imageNamed: ImageNamingConstant.darkness ), 
        size   : CGSize    = ValueProvider.screenDimension
    ) {
        super.init (
            texture: texture,
            color  : .clear,
            size   : size
        )
        
        self.name = NodeNamingConstant.darkness
        self.physicsBody = Darkness.defaultPhysicsBody()
        attachAnimation()
    }
    
    func attachAnimation () {
        let textureName = ImageNamingConstant.darkness
        let idleTextures : [SKTexture] = (0...59).map { SKTexture( imageNamed: textureName + String($0) ) }
        let idleAction   = SKAction.animate(with: idleTextures, timePerFrame: 0.1)
        
        self.run(SKAction.repeatForever(idleAction), withKey: ActionNamingConstant.idle)
    }
    
    static func defaultPhysicsBody () -> SKPhysicsBody {
        var screenDimension = ValueProvider.screenDimension
            screenDimension.height -= 125
            screenDimension.width = 2000
        let pb = SKPhysicsBody( rectangleOf: screenDimension )
        
            pb.isDynamic          = false
            pb.mass               = 0
            pb.linearDamping      = 1
            pb.friction           = 1
            pb.allowsRotation     = false
            pb.restitution        = 0
        
            pb.categoryBitMask    = BitMaskConstant.darkness
            pb.contactTestBitMask = BitMaskConstant.player
        
            pb.usesPreciseCollisionDetection = true
        
        return pb
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
