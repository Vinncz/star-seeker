import SpriteKit

class BasePlatform : InertPlatform {
    
    override init ( 
        texture: SKTexture = SKTexture( imageNamed: ImageNamingConstant.Platform.Inert.base ), 
        size   : CGSize    = CGSize( width: ValueProvider.screenDimension.width, height: ValueProvider.screenDimension.height )
    ) {
        super.init(texture: texture, size: size)        
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
