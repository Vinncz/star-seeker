import SpriteKit

extension SKNode {
        
    func calculateSize () -> CGSize {
        var minX: CGFloat = CGFloat.infinity
        var minY: CGFloat = CGFloat.infinity
        var maxX: CGFloat = -CGFloat.infinity
        var maxY: CGFloat = -CGFloat.infinity

        for child in self.children {
            let frame = child.frame
            minX = min(minX, frame.minX)
            minY = min(minY, frame.minY)
            maxX = max(maxX, frame.maxX)
            maxY = max(maxY, frame.maxY)
        }

        return CGSize (
            width: maxX - minX, 
            height: maxY - minY
        )
    }
    
}
