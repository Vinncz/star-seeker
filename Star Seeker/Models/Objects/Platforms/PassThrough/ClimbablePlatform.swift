import SpriteKit

class ClimbablePlatform : PassTroughPlatform {
    
    override init ( 
        texture: SKTexture = SKTexture( imageNamed: ImageNamingConstant.Platform.PassThrough.climbable ), 
        size   : CGSize    = CGSize( width: ValueProvider.screenDimension.width, height: ValueProvider.screenDimension.height )
    ) {
        super.init(texture: texture, size: size) 
        self.name = NodeNamingConstant.Platform.PassThrough.climbable
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
