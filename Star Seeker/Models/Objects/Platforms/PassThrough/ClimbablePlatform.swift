import SpriteKit

class ClimbablePlatform : Platform {
    
    override var role : String {
        ImageNamingConstant.Platform.PassThrough.prefix + ImageNamingConstant.Platform.PassThrough.climbable
    } 
    
    override init ( themed: Season, size: CGSize = ValueProvider.gridDimension ) {        
        super.init(themed: themed, size: size)
        self.prepare()
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
