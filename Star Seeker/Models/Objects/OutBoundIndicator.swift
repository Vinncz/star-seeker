//
//  PlayerIndicator..swift
//  Star Seeker
//
//  Created by Elian Richard on 22/06/24.
//

import SpriteKit


class OutBoundIndicator: SKSpriteNode {
    init (texture: SKTexture = SKTexture(imageNamed: ImageNamingConstant.Interface.outboundIndicator)) {
        super.init (
            texture: texture,
            color  : .clear,
            size   : texture.size()
        )
        
        self.name = NodeNamingConstant.outboundIndicator
        self.zPosition = 30
    }
    
    
    /* Inherited from SKNode. Refrain from altering the following */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
