//
//  TransactionEmissionsCalculatorView.swift
//  Carbon
//
//  Created by Harsh on 17/03/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct TransactionEmissionsCalculator {
    struct State: Equatable {
        var query: EmissionsQuery
        
        init(query: EmissionsQuery) {
            self.query = query
        }
        
        init(transaction: Transaction) {
            self.query = EmissionsQuery(emission_factor: .init(activity_id: transaction.category.activity_id), parameters: .init())
        }
    }
    
    enum Action {
        
    }
}

struct TransactionEmissionsCalculatorView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    TransactionEmissionsCalculatorView()
}
