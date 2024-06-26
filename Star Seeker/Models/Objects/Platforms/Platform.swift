import SpriteKit

/// The base class that describes any "landable piece of land, that enables the player to not fall".
class Platform : SKSpriteNode, Identifiable {
    
    /// Instanciates the most rudimentary platform, with the appearance of BasePlatform.
    /// 
    /// It first initializes a transparent, textureless SKSpriteNode, then patches it using the ``prepare()`` method.
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
    /// 3. prepareAction
    /// 4. prepareExtras
    func prepare () {
        let texture      : SKTexture         = prepareTexture()
        let physicsBody  : SKPhysicsBody     = preparePhysicsBody(texture: texture, size: size)
        let actionDict   : [String:SKAction] = prepareAction()
        
        prepareDefault()
        
        self.texture     = texture
        self.physicsBody = physicsBody
        self.actionPool  = actionDict
        
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
        return 
            Platform.defaultPhysicsBody(texture: texture, size: size)
    }
    
    
    /// Creates a dictionary of [String: SKAction] to be saved by the platform.
    /// These actions will not perform by itself, until ordered so by calling ``playAction(named:completion:)``
    /// 
    /// This method is intended to be overriden by a subclass, while still providing the default implementation if not overriden.
    /// 
    /// You can alter this method to make a custom dictionary of SKActions that an instance of a platform will save.
    /// For example, if you intend for a platform to move around: you could anticipate the movement in advance, then signal for it to perform the movement you requested once the time is right.
    func prepareAction () -> [String: SKAction] {
        return [:]
    }
    
    
    /// Boilerplate method which implements the same behavior, across many instances and subclasses of platform.
    /// 
    /// I'm not sure on what to make of this. Figured this might come in handy in the future.
    private func prepareDefault () -> Void {}
    
    
    /// The method from which you finalize things up.
    /// Everything done within the scope of this method is performed at the last stage of preparation.
    /// 
    /// This method is intended to be overriden by a subclass. 
    /// 
    /// You can alter this method to do almost anything.
    /// For example, you might use this method to set up your platform's name, bitmask constant, etc.
    /// 
    /// Since this method is to execute last, it has the final say to override any configuration set by previous stages of preparation.
    func prepareExtras () -> Void {
        self.name = NodeNamingConstant.Platform.platform
    }
    
    
    /// Affects which SKTexture will ``prepareTexture()``  generate: be it summer textures, winters', etc.
    let theme: Season
    
//    
//    /// Stores a pair of String-SKAction to be retrieved and performed later by the platform.
//    var actionPool: [String: SKAction] = [:]
    
    
    /// The differentiating factor, of which the extenders of Platform class must modify.
    /// 
    /// Role acts as a suffix, from which the ``prepareTexture()`` will refer to, in order to instanciate the correct SKTexture for platform.
    var role: String {
        ImageNamingConstant.Platform.Inert.prefix + ImageNamingConstant.Platform.Inert.base
    }
    
    
    let id = UUID()
    
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/* MARK: -- Extension which provides Platform with convenient functions */
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

/* MARK: -- Extension which enables the creation of Platform objects, by the way of chaining methods together */
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
