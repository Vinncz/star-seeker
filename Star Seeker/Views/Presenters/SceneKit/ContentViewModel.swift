import SwiftUI
import SceneKit

enum TowerSeason: String {
    case autumn = "AutumnBG"
    case winter = "WinterBG"
    case spring = "SpringBG"
    case summer = "SummerBG"
}

@Observable class ContentViewModel {
    var scene: SCNScene
    var swipeCounter = 0
    var backgroundIndex = 0
    var textureIndex = 0
    let backgrounds = ["AutumnBG", "WinterBG", "SpringBG", "SummerBG"]
    let textures = ["towerAutumnTexture", "towerWinterTexture", "towerSpringTexture", "towerSummerTexture"]
    var towerLayer1: SCNNode!
    var autumnMaterial: SCNMaterial!
    var winterMaterial: SCNMaterial!
    var springMaterial: SCNMaterial!
    var summerMaterial: SCNMaterial!

    init(scene: String) {
        guard let scene = SCNScene(named: scene) else {
            fatalError("Failed to load the scene")
        }
        self.scene = scene
        setupScene()
    }
    
    private func setupScene() {
        guard let TowerLayer1Node = scene.rootNode.childNode(withName: "winterTower", recursively: true) else {
            fatalError("Failed to find one or more required nodes")
        }
        
        towerLayer1 = TowerLayer1Node
        setupMaterials()
        towerLayer1.geometry?.materials = [autumnMaterial]
    }
    
    private func setupMaterials() {
        autumnMaterial = createMaterial(named: "towerAutumnTexture")
        winterMaterial = createMaterial(named: "towerWinterTexture")
        springMaterial = createMaterial(named: "towerSpringTexture")
        summerMaterial = createMaterial(named: "towerSummerTexture")
    }
    
    private func createMaterial(named imageName: String) -> SCNMaterial {
        let material = SCNMaterial()
        guard let image = UIImage(named: imageName) else {
            fatalError("Failed to load texture image: \(imageName)")
        }
        material.diffuse.contents = image
        return material
    }
    
    func handleSwipe() {
        self.state = .progressing
        rotateTower()
    }
    
    private func rotateTower() {
        let zoomOut = SCNAction.move(by: SCNVector3(x: 0, y: 4, z: 0), duration: 0.8)
        let rotateTower = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(-Double.pi / 2), duration: 0.8)
        let zoomIn = SCNAction.move(by: SCNVector3(x: 0, y: -4, z: 0), duration: 0.5)
        let increaseTowerHeight = SCNAction.move(by: SCNVector3(x: 0, y: 0, z: -0.3), duration: 0.8)
        
        let actionGroup = SCNAction.group([zoomOut, rotateTower, increaseTowerHeight])
        let actionSequence = SCNAction.sequence([.wait(duration: 2), actionGroup, zoomIn])
        towerLayer1.runAction(actionSequence)
        
        self.scene.rootNode.runAction(.wait(duration: 4)) {
            self.state = .finished
        }
    }

    func changeToSeason(_ season: TowerSeason) {
        guard let backgroundImage = UIImage(named: season.rawValue) else {
            fatalError("Failed to load the background image: \(season.rawValue)")
        }
        scene.background.contents = backgroundImage
        
        switch season {
        case .autumn:
            towerLayer1.geometry?.materials = [autumnMaterial]
        case .winter:
            towerLayer1.geometry?.materials = [winterMaterial]
        case .spring:
            towerLayer1.geometry?.materials = [springMaterial]
        case .summer:
            towerLayer1.geometry?.materials = [summerMaterial]
        }
        
        resetTowerPosition()
    }
    
    func resetTowerPosition() {
        towerLayer1.position = SCNVector3(x: 0, y: 0, z: -0.211)
    }

    
    var state : BackgroundState = .ready {
        didSet {
            debug("scene state: \(state)")
        }
    }
}

extension ContentViewModel {
        
    enum BackgroundState {
        case ready,
             progressing,
             finished
    }
    
}
