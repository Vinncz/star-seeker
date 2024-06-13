//
//  CoreGraphics.swift
//  Star Seeker
//
//  Created by Elian Richard on 10/06/24.
//

import CoreGraphics

extension CGPoint {
    init(xGrid: Int, yGrid: Int, unitSize: CGFloat) {
        self.init(x: (CGFloat(xGrid) * unitSize) + (unitSize * 0.5), y: (CGFloat(yGrid) * unitSize) + (unitSize * 0.5))
    }
    
    init(xGrid: Int, yGrid: Int, width: Int, height: Int, unitSize: CGFloat) {
        self.init(x: (CGFloat(xGrid) * unitSize) + (unitSize * CGFloat(width) * 0.5), y: (CGFloat(yGrid) * unitSize) + (unitSize * CGFloat(height) * 0.5))
    }
}

extension CGFloat {
    func rounded(toPlaces places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}
