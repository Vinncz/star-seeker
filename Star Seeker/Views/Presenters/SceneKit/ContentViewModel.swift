import SwiftUI
import SceneKit

enum TowerSeason: String {
    case autumn = "AutumnBG"
    case winter = "WinterBG"
    case spring = "SpringBG"
    case summer = "SummerBG"
}

class ContentViewModel: ObservableObject {
    @Published var scene: SCNScene
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
        rotateTower()
    }
    
    private func rotateTower() {
        let zoomOut = SCNAction.move(by: SCNVector3(x: 0, y: 4, z: 0), duration: 0.8)
        let rotateTower = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(-Double.pi / 2), duration: 0.8)
        let zoomIn = SCNAction.move(by: SCNVector3(x: 0, y: -4, z: 0), duration: 0.5)
        let increaseTowerHeight = SCNAction.move(by: SCNVector3(x: 0, y: 0, z: -0.3), duration: 0.8)
        
        let actionGroup = SCNAction.group([zoomOut, rotateTower, increaseTowerHeight])
        let actionSequence = SCNAction.sequence([actionGroup, zoomIn])
        towerLayer1.runAction(actionSequence)
        
        self.state = .finished
    }

    func changeToSeason(_ season: TowerSeason) {
        // Update background
        guard let backgroundImage = UIImage(named: season.rawValue) else {
            fatalError("Failed to load the background image: \(season.rawValue)")
        }
        scene.background.contents = backgroundImage
        
        // Update texture
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
        
        // Reset tower position
        resetTowerPosition()
    }
    
    private func resetTowerPosition() {
        // Set the tower's position and rotation to the initial values
        towerLayer1.position = SCNVector3(x: 0, y: 0, z: -0.211)
//        towerLayer1.rotation = SCNVector4(x: 0, y: 0, z: 0, w: 0)
    }
    
    func waitAndExcecute(duration: TimeInterval, completion: @escaping () -> Void) {
        let waitAction = SCNAction.wait(duration: duration)
        let runAction = SCNAction.run { _ in completion() }
        let sequence = SCNAction.sequence([waitAction, runAction])
        
        // Assuming you have a node to run this action on, for example, the root node of the scene
        towerLayer1.runAction(sequence)
    }

    
    var state : BackgroundState = .ready {
        didSet {
            switch ( state ) {
                case .progressing:
                    self.handleSwipe()
                default:
                    break
            }
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

