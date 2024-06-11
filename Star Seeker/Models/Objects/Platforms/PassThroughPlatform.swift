import SpriteKit

class PassTroughPlatform : SKSpriteNode {
    
    init ( 
        texture: SKTexture = SKTexture( imageNamed: ImageNamingConstant.Platform.PassThrough.passThrough ), 
        size   : CGSize    = CGSize( width: ValueProvider.screenDimension.width, height: ValueProvider.screenDimension.height )
    ) {
        super.init (
            texture : texture, 
            color   : .clear,
            size    : size
        )
        
        self.name = NodeNamingConstant.Platform.platform
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
