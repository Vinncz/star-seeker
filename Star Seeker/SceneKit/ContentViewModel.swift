import SwiftUI
import SceneKit

class ContentViewModel: ObservableObject {
    @Published var scene: SCNScene
    var swipeCounter = 0
    var backgroundIndex = 0
    var textureIndex = 0
    let backgrounds = ["AutumnBG", "WinterBG", "SpringBG", "SummerBG"]
    let textures = ["towerAutumnTexture", "towerWinterTexture", "towerSpringTexture", "towerSummerTexture"]
    var towerLayer1: SCNNode!
    var towerLayer2: SCNNode!
    var autumnMaterial: SCNMaterial!
    var winterMaterial: SCNMaterial!
    var springMaterial: SCNMaterial!
    var cameraNode: SCNNode!
    var scnView: SCNView!
    
    init(scene: String) {
        guard let scene = SCNScene(named: scene) else {
            fatalError("Failed to load the scene")
        }
        self.scene = scene
        setupScene()
    }
    
    private func setupScene() {
        guard let TowerLayer1Node = scene.rootNode.childNode(withName: "TowerLayer1Node", recursively: true),
              let TowerLayer2Node = scene.rootNode.childNode(withName: "TowerLayer2Node", recursively: true),
              let camNode = scene.rootNode.childNode(withName: "camNode", recursively: true) else {
            fatalError("Failed to find one or more required nodes")
        }
        
        towerLayer1 = TowerLayer1Node
        towerLayer2 = TowerLayer2Node
        
        setupCamera(at: camNode.position, with: camNode.rotation)
        setupSCNView()
        setupMaterials()
        
        towerLayer2.geometry?.materials = [winterMaterial]
        towerLayer1.geometry?.materials = [autumnMaterial]
        
        winterMaterial.transparency = 1.0
    }
    
    private func setupCamera(at position: SCNVector3, with rotation: SCNVector4) {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = position
        cameraNode.rotation = rotation
        scene.rootNode.addChildNode(cameraNode)
    }
    
    private func setupSCNView() {
        scnView = SCNView()
        scnView.scene = scene
        scnView.pointOfView = cameraNode
    }
    
    private func setupMaterials() {
        autumnMaterial = createMaterial(named: "towerAutumnTexture")
        winterMaterial = createMaterial(named: "towerWinterTexture")
        springMaterial = createMaterial(named: "towerSpringTexture")
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
        swipeCounter += 1
        if swipeCounter == 3 {
            changeBackgroundAndTexture()  // Mengganti background dan tekstur
            swipeCounter = 0
        }
        rotateTower()
    }
    
    private func changeBackgroundAndTexture() {
        // Update background
        backgroundIndex = (backgroundIndex + 1) % backgrounds.count
        let backgroundName = backgrounds[backgroundIndex]
        guard let backgroundImage = UIImage(named: backgroundName) else {
            fatalError("Failed to load the background image: \(backgroundName)")
        }
        scene.background.contents = backgroundImage

        // Update texture
        textureIndex = (textureIndex + 1) % textures.count
        let textureName = textures[textureIndex]
        guard let textureImage = UIImage(named: textureName) else {
            fatalError("Failed to load the texture image: \(textureName)")
        }
        
        // Fade out the current material
        let fadeOutAction = SCNAction.fadeOut(duration: 0.3)
        let fadeOutGroup = SCNAction.group([fadeOutAction])
        
        // Fade in the new material
        let fadeInAction = SCNAction.fadeIn(duration: 0.6)
        let fadeInGroup = SCNAction.group([SCNAction.run { _ in
            self.winterMaterial.diffuse.contents = textureImage
            self.springMaterial.diffuse.contents = textureImage
            self.autumnMaterial.diffuse.contents = textureImage
        }, fadeInAction])
        
        towerLayer1.runAction(fadeOutGroup)
        towerLayer2.runAction(fadeOutGroup)
        
        towerLayer1.runAction(fadeInGroup)
        towerLayer2.runAction(fadeInGroup)
    }

    
    private func animateMaterialTransparency(to value: CGFloat, duration: TimeInterval) -> SCNAction {
        return SCNAction.fadeOpacity(to: value, duration: duration)
    }
    
    private func rotateTower() {
        let zoomOut = SCNAction.move(by: SCNVector3(x: 0, y: 4, z: 0), duration: 0.8)
        let rotateTower = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(-Double.pi / 2), duration: 0.8)
        let zoomIn = SCNAction.move(by: SCNVector3(x: 0, y: -4, z: 0), duration: 0.5)
        let increaseTowerHeight = SCNAction.move(by: SCNVector3(x: 0, y: 0, z: -0.3), duration: 0.8)
        
        let actionGroup = SCNAction.group([zoomOut, rotateTower, increaseTowerHeight])
        let actionSequence = SCNAction.sequence([actionGroup, zoomIn])
        
        towerLayer2.runAction(actionSequence)
        towerLayer1.runAction(actionSequence)
    }
}
