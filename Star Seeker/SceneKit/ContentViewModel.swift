

import SwiftUI
import SceneKit

class ContentViewModel: ObservableObject {
    @Published var scene: SCNScene
    var swipeCounter = 0
    var towerAutumn: SCNNode!
    var towerWinter: SCNNode!
    var autumnMaterial: SCNMaterial!
    var winterMaterial: SCNMaterial!
    var cameraNode: SCNNode!
    var scnView: SCNView!
    var camNode: SCNNode!
    
    init(scene: String) {
        guard let scene = SCNScene(named: scene) else {
            fatalError("Failed to load the scene")
        }
        self.scene = scene
        setupScene()
    }
    
    private func setupScene() {
        guard let towerAutumnNode = scene.rootNode.childNode(withName: "autumnNode", recursively: true) else {
                    fatalError("Failed to find the autumnNode")
                }
                towerAutumn = towerAutumnNode
        guard let towerWinterNode = scene.rootNode.childNode(withName: "winterTower", recursively: true) else {
                    fatalError("Failed to find the autumnNode")
                }
                towerWinter = towerWinterNode

        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)

        guard let camNode = scene.rootNode.childNode(withName: "camNode", recursively: true) else {
            fatalError("Failed to find the camNode")
        }
        cameraNode.position = camNode.position
        cameraNode.rotation = camNode.rotation

        
        scnView = SCNView()
                scnView.scene = scene
                scnView.pointOfView = cameraNode
        
        autumnMaterial = SCNMaterial()
        if let autumnTextureImage = UIImage(named: "towerAutumnTexture") {
            autumnMaterial.diffuse.contents = autumnTextureImage
        } else {
            fatalError("Failed to load the autumn texture image")
        }
        
        winterMaterial = SCNMaterial()
        if let winterTextureImage = UIImage(named: "towerWinterTexture") {
            winterMaterial.diffuse.contents = winterTextureImage
        } else {
            fatalError("Failed to load the winter texture image")
        }
        
        towerWinter.geometry?.materials = [winterMaterial]
        // Initialize with autumn material
        towerAutumn.geometry?.materials = [autumnMaterial]

        // Set initial transparency
        winterMaterial.transparency = 1.0
        
    }
    
    func handleSwipe() {
        swipeCounter += 1
        if swipeCounter == 3 {
            changeBackground()
            switchTextures()
            swipeCounter = 0
        }
        rotateTower()
    }
    
    func animateAutumnMaterialTransparency() -> SCNAction {
        let transparencyAction = SCNAction.fadeOut(duration: 0.3)
        return transparencyAction
    }

    // Function to animate the transparency of winterMaterial
    func animateWinterMaterialTransparency() -> SCNAction {
        let transparencyAction = SCNAction.fadeIn(duration: 0.6)
        return transparencyAction
    }

    // Swipe button action
    func switching() {
        let autumnAction = animateAutumnMaterialTransparency()
        let winterAction = animateWinterMaterialTransparency()

        let groupAction = SCNAction.group([autumnAction, winterAction])

        towerAutumn.runAction(groupAction)
        towerWinter.runAction(groupAction)
    }
    
    private func changeBackground() {
        if let image = UIImage(named: "WinterBG") {
            scene.background.contents = image
        } else {
            fatalError("Failed to load the background image")
        }
    }
    
    private func switchTextures() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.6
        autumnMaterial.transparency = 0.0
        winterMaterial.transparency = 1.0
        SCNTransaction.commit()
    }
    
    private func rotateTower() {
        let zoomOut = SCNAction.move(by: SCNVector3(x: 0, y: 4, z: 0), duration: 0.8)
        let rotateTower = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(-Double.pi / 2), duration: 0.8)
        let zoomIn = SCNAction.move(by: SCNVector3(x: 0, y: -4, z: 0), duration: 0.5)
        let increaseTowerHeight = SCNAction.move(by: SCNVector3(x: 0, y: 0, z: -0.3), duration: 0.8)

        let actionGroup = SCNAction.group([zoomOut, rotateTower, increaseTowerHeight])
        let actionSequence = SCNAction.sequence([actionGroup, zoomIn])

        towerWinter.runAction(actionSequence)
        towerAutumn.runAction(actionSequence)
        
    }
}
