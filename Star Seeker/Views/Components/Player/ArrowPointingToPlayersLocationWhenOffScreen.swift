import SpriteKit

class ArrowPointingToPlayersLocationWhenOffScreen : SKSpriteNode {
    
    init (texture: SKTexture = SKTexture(imageNamed: ImageNamingConstant.Interface.Indicator.arrowPointingToPlayersLocationWhenOffScreen)) {
        super.init (
            texture: texture,
            color  : .clear,
            size   : texture.size()
        )

        self.name = NodeNamingConstant.Indicator.arrowPointingToPlayersLocationWhenOffScreen
    }

    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
