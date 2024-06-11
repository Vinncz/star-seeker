//
//  CGFLoat.swift
//  Star Seeker
//
//  Created by Elian Richard on 12/06/24.
//

import Foundation

extension CGFloat {
    func rounded(toPlaces places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}
