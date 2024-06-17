import SpriteKit

class Platform : SKSpriteNode, Identifiable {

    var id = UUID()
    
    init ( 
        texture: SKTexture = SKTexture( imageNamed: ImageNamingConstant.Platform.Inert.base ), 
        size   : CGSize    = ValueProvider.gridDimension
    ) {
        super.init (
            texture: texture, 
            color  : .clear, 
            size   : size
        )
        
        self.name = NodeNamingConstant.Platform.platform
        self.physicsBody = Platform.defaultPhysicsBody( texture: texture, size: size )
    }
    
    static func defaultPhysicsBody ( texture: SKTexture, size: CGSize ) -> SKPhysicsBody {
        let pb = SKPhysicsBody( texture: texture, size: size )
        
        pb.isDynamic          = false
        pb.restitution        = 0
        pb.allowsRotation     = false
        pb.friction           = GameConfig.baseFrictionModifier
        
        pb.categoryBitMask    = BitMaskConstant.platform
        pb.contactTestBitMask = BitMaskConstant.player
        
        return pb
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
