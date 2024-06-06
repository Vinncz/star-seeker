//
//  Item.swift
//  Star Seeker
//
//  Created by Vin on 06/06/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
