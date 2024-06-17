import Foundation
import Observation

/// Class which holds computed value, and provides it globally. 
/// 
/// Value contained within are only available after the initialization or even presentation of some screens. 
@Observable class ValueProvider {
    
    static var screenDimension : CGSize = CGSize( width: 393, height: 852 )
    static var gridDimension   : CGSize {
        CGSize (
            width  : screenDimension.width / GameConfig.playArea.width,
            height : screenDimension.width / GameConfig.playArea.width
        )
    }
    static var playerDimension : CGSize {
        CGSize (
            width : gridDimension.width * 1.5,
            height: gridDimension.width * 1.5
        )
    }
    static var playerPhysicsBodyDimension : CGSize {
        CGSize (
            width : gridDimension.width * 0.6,
            height: gridDimension.width * 1.2
        )
    }
    
}
