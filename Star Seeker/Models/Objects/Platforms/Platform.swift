import SpriteKit

class Platform : SKSpriteNode, Identifiable {
    let id    = UUID()
    let theme : Season
    var role  : String {
        ImageNamingConstant.Platform.Inert.prefix + ImageNamingConstant.Platform.Inert.base
    } 
    
    init ( themed: Season, size: CGSize = ValueProvider.gridDimension ) {
        self.theme = themed
        
        super.init (
            texture: nil,
            color  : .clear,
            size   : size
        )
        
        self.prepare()
    }
    
    /// Prepares the platform for presentation. It is immidiately run ___after___ the initialization of platform.
    /// 
    /// Ideally, this method is called only once; by the initializer.
    /// 
    /// The sequence of execution is as follows:
    /// 1. prepareTexture
    /// 2. preparePhysicsBody
    /// 3. prepareExtras
    func prepare () {
        let texture      : SKTexture     = prepareTexture()
        let physicsBody  : SKPhysicsBody = preparePhysicsBody(texture: texture, size: size)
        prepareDefault()
        self.texture     = texture
        self.physicsBody = physicsBody
        
        prepareExtras()
    }
    
    /// Creates an instance of SKTexture for the platform to use.
    /// 
    /// This method is intended to be overriden by a subclass, while still providing the default implementation if not overriden.
    /// 
    /// You can alter this method to instanciate any custom SKTexture to be used by the platform.
    /// For example, you might use this method to give the platform a different texture; one icy and one spiky.
    func prepareTexture () -> SKTexture {
        var texture : String = ImageNamingConstant.Platform.prefix
        
        switch ( theme ) {
            case .notApplicable:
                texture += ImageNamingConstant.Platform.Seasonal.nonseasonal + role
                break
            case .autumn, .winter, .spring, .summer:
                texture += ImageNamingConstant.Platform.Seasonal.seasonal + theme.rawValue + role
                break
        }
        
        return SKTexture(imageNamed: texture)
    }
    
    /// Creates an instance of SKPhysicsBody for the platform to use.
    /// 
    /// This method is intended to be overriden by a subclass, while still providing the default implementation if not overriden.
    /// 
    /// You can alter this method to instanciate any custom SKPhysicsBody to be used by the platform.
    /// For example, you might use this method to give the platform a friction value less than what is was by default.
    func preparePhysicsBody ( texture: SKTexture, size: CGSize ) -> SKPhysicsBody {
        return Platform.defaultPhysicsBody(texture: texture, size: size)
    }
    
    private func prepareDefault () -> Void {
        // global preset
    }
    
    /// The method from which you finalize things up.
    /// 
    /// This method is intended to be overriden by a subclass. 
    /// 
    /// Everything done within the scope of this method is performed at the last stage of preparation -- meaning this method has the final say to override any configuration set by previous stages of preparation.
    func prepareExtras() -> Void {
        self.name = NodeNamingConstant.Platform.platform
    }
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Platform {
    /// Instanciates the default preset of SKPhysicsBody for a platform to use. Appropriate for any platform with default friction values.
    /// 
    /// Make caution, for a single instance of SKPhysicsBody can only be used by 1 (one) instance of SKNode.
    static func defaultPhysicsBody ( texture: SKTexture, size: CGSize ) -> SKPhysicsBody {
        let pb = SKPhysicsBody( polygonFrom: UIBezierPath(roundedRect: CGRect(x: -size.width * 0.5, y: -size.height * 0.5, width: size.width, height: size.height), cornerRadius: 2).cgPath )
        
            pb.isDynamic          = GameConfig.platformIsDynamic
            pb.restitution        = GameConfig.platformRestitution
            pb.allowsRotation     = GameConfig.platformRotates
            pb.friction           = GameConfig.platformFriction
                    
            pb.categoryBitMask    = BitMaskConstant.platform
            pb.contactTestBitMask = BitMaskConstant.player
        
        return pb
    }
}

extension Platform {
    func enableCollisionWith ( _ pb: SKPhysicsBody ) -> Self {
        self.physicsBody?.contactTestBitMask |= pb.contactTestBitMask
        return self
    }
    func withName ( _ to: String ) -> Self {
        self.name = to
        return self
    }
    func withCategoryBitMask ( _ to: UInt32 ) -> Self {
        self.physicsBody?.categoryBitMask = to
        return self
    }
    func withCollisionBitMask ( _ to: UInt32 ) -> Self {
        self.physicsBody?.collisionBitMask = to
        return self
    }
    func withContactTestBitMask ( _ to: UInt32 ) -> Self {
        self.physicsBody?.contactTestBitMask = to
        return self
    }
}
