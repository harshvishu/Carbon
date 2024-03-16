//
//  TransactionDetailsView.swift
//  Carbon
//
//  Created by Harsh on 15/03/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct TransactionDetail {
    @ObservableState
    struct State: Equatable, Identifiable {
        let id = UUID()
        var amount: Double
        var description: String
        var type: TransactionType
        var category: TransactionCategory
        var date: Date = Date()
        var fromAccount: String = ""
    }
}

struct TransactionDetailsView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    TransactionDetailsView()
}
