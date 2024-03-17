//
//  Tab.swift
//  Carbon
//
//  Created by Harsh on 16/03/24.
//

import Foundation
import SwiftUI

enum Tab: CaseIterable, Identifiable {
    case dashboard
    case cards
    case pay
    case carbon
    
    var showTitle: Bool {
        switch self {
        case .dashboard:
            return false
        case .cards:
            return false
        case .pay:
            return false
        case .carbon:
            return false
        }
    }
    
    var title: String {
        switch self {
        case .dashboard:
            "Dashboard"
        case .cards:
            "Cards"
        case .pay:
            "Pay"
        case .carbon:
            "Emissions"
        }
    }
    
    var id: Self {
        self
    }
    
    @ViewBuilder
    var image: some View {
        switch self {
        case .dashboard:
            Image(systemName: "house.fill")
        case .cards:
            Image(systemName: "creditcard.fill")
        case .pay:
            Image(systemName: "qrcode.viewfinder")
        case .carbon:
            EntryWidgetView()
        }
    }
}
