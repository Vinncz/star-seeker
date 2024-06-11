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
    
}
