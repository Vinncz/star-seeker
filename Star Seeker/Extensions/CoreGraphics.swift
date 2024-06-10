//
//  CoreGraphics.swift
//  Star Seeker
//
//  Created by Elian Richard on 10/06/24.
//

import CoreGraphics

extension CGPoint {
    init(xGrid: Int, yGrid: Int, unitSize: CGFloat) {
        self.init(x: (CGFloat(xGrid) * unitSize) + unitSize * 0.5, y: (CGFloat(yGrid) * unitSize) + unitSize * 0.5)
    }
}
