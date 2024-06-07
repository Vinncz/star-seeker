import SpriteKit
import SwiftUI

class Game : SKScene {
        
    override func didMove ( to view: SKView ) {
        view.allowsTransparency = true
        self.view!.isMultipleTouchEnabled = true
        self.backgroundColor = .clear
    }
    
    override func sceneDidLoad () {
       // MARK: - One time scene setup
        
    }
    
}
