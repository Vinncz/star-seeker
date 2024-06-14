import SpriteKit

class Platform : SKSpriteNode, Identifiable {

    var id = UUID()
    
    init ( 
        texture: SKTexture = SKTexture( imageNamed: ImageNamingConstant.Platform.Inert.base ), 
        size   : CGSize    = ValueProvider.gridDimension
    ) {
        super.init (
            texture : texture, 
            color   : .clear, 
            size    : size
        )
        
        self.name = NodeNamingConstant.Platform.platform
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.restitution = 0
        self.physicsBody?.friction = GameConfig.baseFrictionModifier
        
        self.physicsBody?.categoryBitMask    = BitMaskConstant.platform
        self.physicsBody?.contactTestBitMask = BitMaskConstant.player
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
