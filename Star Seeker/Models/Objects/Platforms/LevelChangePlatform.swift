import SpriteKit

class LevelChangePlatform : Platform {
    
    override var role : String {
        ImageNamingConstant.Platform.PassThrough.prefix + ImageNamingConstant.Platform.Inert.base
    }
    
    override init ( themed: Season, size: CGSize = ValueProvider.gridDimension ) {        
        super.init(themed: themed, size: size)
        self.prepare()
    }
    
    override func preparePhysicsBody ( texture: SKTexture, size: CGSize ) -> SKPhysicsBody {
        let pb                 = Platform.defaultPhysicsBody(texture: texture, size: size)
            pb.categoryBitMask = BitMaskConstant.levelChangePlatform
        
        return pb
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
