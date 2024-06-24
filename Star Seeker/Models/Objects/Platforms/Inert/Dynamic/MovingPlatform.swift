import SpriteKit

/** Platform which moves around in a predicted path of movement */
class MovingPlatform : DynamicPlatform {
    
    var movementVector : CGVector = CGVector(dx: 0, dy: 0)
    
    override var role : String {
        ImageNamingConstant.Platform.Inert.prefix + ImageNamingConstant.Platform.Inert.Dynamic.prefix + ImageNamingConstant.Platform.Inert.Dynamic.moving
    } 
    
    override init ( themed: Season, size: CGSize = ValueProvider.gridDimension ) {        
        super.init(themed: themed, size: size)
        self.prepare()
    }
    
    init ( themed: Season, movingTo: CGVector, size: CGSize = ValueProvider.gridDimension ) {
        self.movementVector = movingTo
        super.init(themed: themed, size: size)
        self.prepare()
    }
    
    override func preparePhysicsBody ( texture: SKTexture, size: CGSize ) -> SKPhysicsBody {
        let pb = SKPhysicsBody(texture: texture, size: size)
        
            pb.isDynamic          = GameConfig.platformIsDynamic
            pb.restitution        = GameConfig.platformRestitution
            pb.allowsRotation     = GameConfig.platformRotates
            pb.friction           = 1
                    
            pb.categoryBitMask    = BitMaskConstant.movingPlatform
            pb.contactTestBitMask = BitMaskConstant.player
        
        return pb
    }
    
    override func prepareAction () -> [String : SKAction] {
        var map : [String: SKAction] = [:]
            map = [
                ActionNamingConstant.movingPlatformMovement : SKAction.repeatForever(
                    SKAction.sequence([
                        SKAction.moveBy(x: movementVector.dx, y: movementVector.dy, duration: 3).withTimingModeOf(.easeInEaseOut),
                        SKAction.wait(forDuration: 1),
                        SKAction.moveBy(x: -movementVector.dx, y: -movementVector.dy, duration: 3).withTimingModeOf(.easeInEaseOut),
                        SKAction.wait(forDuration: 1)
                    ])
                )
            ]
        
        return map
    }
    
    override func prepareExtras() {
        self.name = NodeNamingConstant.Platform.Inert.Dynamic.moving
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
