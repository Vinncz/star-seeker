import SpriteKit

/** Platform which self destruct within moments after player stepped on it */
class CollapsiblePlatform : DynamicPlatform {
    
    override var role : String {
        ImageNamingConstant.Platform.Inert.prefix + ImageNamingConstant.Platform.Inert.Dynamic.prefix + ImageNamingConstant.Platform.Inert.Dynamic.collapsible
    } 
    
    override init ( themed: Season, size: CGSize = ValueProvider.gridDimension ) {        
        super.init(themed: themed, size: size)
        self.prepare()
    }
    
    override func preparePhysicsBody ( texture: SKTexture, size: CGSize ) -> SKPhysicsBody {
        let pb = SKPhysicsBody(texture: texture, size: size)
        
            pb.isDynamic          = GameConfig.platformIsDynamic
            pb.restitution        = GameConfig.platformRestitution
            pb.allowsRotation     = GameConfig.platformRotates
            pb.friction           = 1
                    
            pb.categoryBitMask    = BitMaskConstant.collapsiblePlatform
            pb.contactTestBitMask = BitMaskConstant.player
        
        return pb
    }
    
    override func prepareAction () -> [String : SKAction] {
        var map : [String: SKAction] = [:]
            map = [
                ActionNamingConstant.collapseOfCollapsiblePlatform : SKAction.sequence (
                    [
                        SKAction.wait(forDuration: 0.5),
                        SKAction.moveBy(x: -5, y: 2, duration: 0.075).withTimingModeOf(.easeInEaseOut),
                        SKAction.wait(forDuration: 0.025),
                        SKAction.moveBy(x: 7, y: -1, duration: 0.075).withTimingModeOf(.easeInEaseOut),
                        SKAction.wait(forDuration: 0.025),
                        SKAction.moveBy(x: -7, y: 3, duration: 0.075).withTimingModeOf(.easeInEaseOut),
                        SKAction.wait(forDuration: 0.025),
                        SKAction.moveBy(x: 5, y: -3, duration: 0.075).withTimingModeOf(.easeInEaseOut),
                        SKAction.wait(forDuration: 0.025),
                        SKAction.moveBy(x: 5, y: -3, duration: 0.075).withTimingModeOf(.easeInEaseOut),
                        SKAction.wait(forDuration: 0.025),
                        SKAction.moveBy(x: -7, y: 3, duration: 0.075).withTimingModeOf(.easeInEaseOut),
                        SKAction.wait(forDuration: 0.025),
                        SKAction.moveBy(x: 7, y: -1, duration: 0.075).withTimingModeOf(.easeInEaseOut),
                        SKAction.wait(forDuration: 0.025),
                        SKAction.moveBy(x: -5, y: 2, duration: 0.075).withTimingModeOf(.easeInEaseOut),
                        SKAction.wait(forDuration: 0.5),
                    ]
                )
            ]
        
        return map
    }
        
    /* Inherited from SKNode. Refrain from altering the following */
    required init? ( coder aDecoder: NSCoder ) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
