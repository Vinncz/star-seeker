import SpriteKit

/** Platform which self destruct within moments after player stepped on it */
class CollapsiblePlatform : DynamicPlatform {
    
    override init ( 
        texture: SKTexture = SKTexture( imageNamed: ImageNamingConstant.Platform.Inert.base ), 
        size   : CGSize    = CGSize( width: ValueProvider.screenDimension.width, height: ValueProvider.screenDimension.height )
    ) {
        super.init(texture: texture, size: size)        
        self.name = NodeNamingConstant.Platform.Inert.Dynamic.collapsible
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
