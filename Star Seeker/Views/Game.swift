import SpriteKit
import SwiftUI

class Game : SKScene {
    override func didMove ( to view: SKView ) {
        print("loaded")
        self.view!.isMultipleTouchEnabled = true
    }
    
    override func sceneDidLoad () {
        self.view?.isMultipleTouchEnabled = true
    }
}
