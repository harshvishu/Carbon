//
//  Item.swift
//  Carbon
//
//  Created by Harsh on 15/03/24.
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
