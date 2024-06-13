import SpriteKit

/** Platform which speeds up the movement of the player */
class SlipperyPlatform : ReactivePlatform {
    
    override init ( 
        texture: SKTexture = SKTexture( imageNamed: ImageNamingConstant.Platform.Reactive.slippery ), 
        size   : CGSize    = CGSize( width: ValueProvider.screenDimension.width, height: ValueProvider.screenDimension.height )
    ) {
        super.init(texture: texture, size: size)
        self.name = NodeNamingConstant.Platform.Reactive.slippery
        
        self.physicsBody?.friction = GameConfig.slipperyFrictionModifier
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
