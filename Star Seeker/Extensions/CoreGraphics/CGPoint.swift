import CoreGraphics

extension CGPoint {
    
    init ( _ nthHorizontalGrid: Int, _ nthVerticalGrid: Int, gridDimension: CGSize = ValueProvider.gridDimension ) {
        
        /** Calculates the offset needed to land on nth-grid + 1 */
        let horizontalGridOffset       = CGFloat(nthHorizontalGrid) * gridDimension.width
        /** Calculates the offset needed to land on the middle of said nth-grid + 1 */
        let totalHorizontalGridOffset  = horizontalGridOffset + ( gridDimension.width / 2 )
        
        /** Calculates the offset needed to land on nth-grid + 1 */
        let verticalGridOffset         = CGFloat(nthVerticalGrid) * gridDimension.height
        /** Calculates the offset needed to land on the middle of said nth-grid + 1 */
        let totalVerticalGridOffset    = verticalGridOffset + ( gridDimension.height / 2 )
        
        self.init (
            x: totalHorizontalGridOffset,
            y: totalVerticalGridOffset
        )
    }
    
    init(xGrid: Int, yGrid: Int, width: Int, height: Int, unitSize: CGFloat = ValueProvider.gridDimension.width) {
        self.init(x: (CGFloat(xGrid) * unitSize) + (unitSize * CGFloat(width) * 0.5), y: (CGFloat(yGrid) * unitSize) + (unitSize * CGFloat(height) * 0.5))
    }
    
    func convertToGrids () -> CGPoint {
        let x = self.x / ValueProvider.gridDimension.width
        let y = self.y / ValueProvider.gridDimension.height
        
        return CGPoint(x: x, y: y)
    }
    
    func toString ( useGrid: Bool ) -> String {
        let grid = self.convertToGrids()
        return useGrid ? "x: \(grid.x + 0.5), y: \(grid.y + 0.51)" : "x: \(self.x), y: \(self.y)"
    }
    
}
