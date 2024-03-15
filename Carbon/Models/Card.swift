//
//  Card.swift
//  Carbon
//
//  Created by Harsh on 15/03/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Card {
    @ObservableState
    struct State: Equatable, Identifiable {
        let id = UUID()
        var name: String
        var amount: Double
        var expiry: String
        var type: CardType
        var number: String
    }
}

enum CardType: String {
    case visa = "visa"
    case mastercard = "master card"
}

