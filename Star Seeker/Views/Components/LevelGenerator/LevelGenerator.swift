import SpriteKit

class LevelGenerator {
    
    let decipherer : Decipherer
    let target     : SKScene
    
    init ( target : SKScene, decipherer: Decipherer ) {
        self.decipherer = decipherer
        self.target     = target
    }
    
    func generate () {
        let result = (self.decipherer.decipher() as! [[SKSpriteNode?]]).reversed()
        var movingPlatformLength = 0
        var movingPlaformTrackLength = 0
        
        for ( rowIndex, row ) in result.enumerated() {
            for ( columnIndex, column ) in row.enumerated() {
                if let column {
                    if (column.name == NodeNamingConstant.Platform.Inert.Dynamic.moving) {
                            movingPlatformLength += 1
                    } 
                    else if (column.name == NodeNamingConstant.Platform.PassThrough.movingTrack) {
                        movingPlaformTrackLength += 1
                    }
                    else {
                        column.position = CGPoint(columnIndex, rowIndex)
                        target.addChild(column)
                    }
                } else {
                    if movingPlatformLength != 0 {
                        let platform = MovingPlatform(size: ValueProvider.customGridDimension(movingPlatformLength, 1))
                        
                        let xStart = columnIndex-movingPlatformLength-movingPlaformTrackLength
                        let xEnd = columnIndex
                        
                        platform.position = CGPoint(xGrid: xStart, yGrid: rowIndex, width: movingPlatformLength, height: 1);                        target.addChild(platform)
                        
                        let distance = CGFloat(xEnd) - CGFloat(xStart) - CGFloat(movingPlatformLength)
                                
                        let platformSpeed = 1.0
                        let platformActionDuration = distance / platformSpeed
                        
                        let moveRight = SKAction.moveBy(x: distance * ValueProvider.gridDimension.width, y: 0, duration: platformActionDuration)
                        let moveLeft = SKAction.moveBy(x: -distance * ValueProvider.gridDimension.width, y: 0, duration: platformActionDuration)
                        
                        let runMoveRight = SKAction.run { platform.run(moveRight, withKey: "moveRight") }
                        let runMoveLeft = SKAction.run { platform.run(moveLeft, withKey: "moveLeft") }
                        
                        let wait = SKAction.wait(forDuration: platformActionDuration)
                        
                        let sequence = SKAction.sequence([runMoveRight, wait, runMoveLeft, wait])
                        let repeatForever = SKAction.repeatForever(sequence)
                        
                        platform.run(repeatForever, withKey: "movingSequence")
                        
                        movingPlaformTrackLength = 0
                        movingPlatformLength = 0
                    }
                }
            }
        }
    }
    
}
