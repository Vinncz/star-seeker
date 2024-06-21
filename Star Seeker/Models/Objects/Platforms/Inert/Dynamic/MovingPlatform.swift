import SpriteKit

/** Platform which moves around in a predicted path of movement */
class MovingPlatform : DynamicPlatform {
    
    override var role : String {
        ImageNamingConstant.Platform.Inert.prefix + ImageNamingConstant.Platform.Inert.Dynamic.prefix + ImageNamingConstant.Platform.Inert.Dynamic.moving
    } 
    
    override init ( themed: Season, size: CGSize = ValueProvider.gridDimension ) {        
        super.init(themed: themed, size: size)
        self.prepare()
    }
    
    override func preparePhysicsBody(texture: SKTexture, size: CGSize) -> SKPhysicsBody {
        let pb = SKPhysicsBody(texture: texture, size: size)
        
            pb.isDynamic          = GameConfig.platformIsDynamic
            pb.restitution        = GameConfig.platformRestitution
            pb.allowsRotation     = GameConfig.platformRotates
            pb.friction           = GameConfig.platformFriction
                    
            pb.categoryBitMask    = BitMaskConstant.platform
            pb.contactTestBitMask = BitMaskConstant.player
        
        return pb
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
