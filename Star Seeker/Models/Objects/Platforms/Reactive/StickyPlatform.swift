import SpriteKit

/** Platform which slows the movement of the player */
class StickyPlatform : ReactivePlatform {
    
    override var role : String {
        ImageNamingConstant.Platform.Reactive.prefix + ImageNamingConstant.Platform.Reactive.sticky
    } 
    
    override init ( themed: Season, size: CGSize = ValueProvider.gridDimension ) {        
        super.init(themed: themed, size: size)
        self.prepare()
    }
    
    override func preparePhysicsBody ( texture: SKTexture, size: CGSize ) -> SKPhysicsBody {
        let pb          = Platform.defaultPhysicsBody(texture: texture, size: size)
            pb.friction = GameConfig.stickyFrictionModifier
        
        return pb
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
