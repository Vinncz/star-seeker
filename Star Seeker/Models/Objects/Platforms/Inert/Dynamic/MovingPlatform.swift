import SpriteKit

/** Platform which moves around in a predicted path of movement */
class MovingPlatform : DynamicPlatform {
    
    override var role : String {
        ImageNamingConstant.Platform.Inert.prefix + ImageNamingConstant.Platform.Inert.Dynamic.prefix + ImageNamingConstant.Platform.Inert.Dynamic.moving
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
