import SpriteKit

/** Platform which speeds up the movement of the player */
class SlipperyPlatform : ReactivePlatform {
    
    override var role : String {
        ImageNamingConstant.Platform.Reactive.prefix + ImageNamingConstant.Platform.Reactive.slippery
    }
    
    override init ( themed: Season, size: CGSize = ValueProvider.gridDimension ) {        
        super.init(themed: themed, size: size)
        self.prepare()
    }
    
    override func preparePhysicsBody ( texture: SKTexture, size: CGSize ) -> SKPhysicsBody {
        let pb                = SKPhysicsBody( polygonFrom: UIBezierPath(roundedRect: CGRect(x: -size.width * 0.5, y: -size.height * 0.5, width: size.width, height: size.height), cornerRadius: 4).cgPath )
            
        pb.isDynamic          = GameConfig.platformIsDynamic
        pb.restitution        = GameConfig.platformRestitution
        pb.allowsRotation     = GameConfig.platformRotates
        pb.friction           = GameConfig.slipperyFrictionModifier
                
        pb.categoryBitMask    = BitMaskConstant.platform
        pb.contactTestBitMask = BitMaskConstant.player
        
        
        return pb
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
