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
        let pb          = Platform.defaultPhysicsBody(texture: texture, size: size)
            pb.friction = GameConfig.slipperyFrictionModifier
        
        return pb
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
