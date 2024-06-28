import SpriteKit

class BeginPlatform : Platform {
    
    override var role : String {
        ImageNamingConstant.Platform.Inert.prefix + ImageNamingConstant.Platform.Inert.levelChange
    }
    
    override init ( themed: Season, size: CGSize = ValueProvider.gridDimension ) {        
        super.init(themed: .notApplicable, size: size)
        self.prepare()
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
