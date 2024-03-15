//
//  TransactionsListView.swift
//  Carbon
//
//  Created by Harsh on 15/03/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
struct TransactionsList {
    @ObservableState
    struct State: Equatable {
        var transactions: IdentifiedArrayOf<Transaction.State> = []
    }
    
    enum Action: Equatable {
        case transactions(IdentifiedActionOf<Transaction>)
    }
    
    var body: some Reducer<State, Action> {
      EmptyReducer()
        .forEach(\.transactions, action: \.transactions) {
            Transaction()
        }
    }
}

struct TransactionsListView: View {
    let store: StoreOf<TransactionsList>
    
    var body: some View {
        ForEach(store.scope(state: \.transactions, action: \.transactions)) {
            TransactionRowView(store: $0)
        }
    }
}

#Preview {
    TransactionsListView(store: StoreOf<TransactionsList>(initialState: TransactionsList.State(), reducer: {
        TransactionsList()
    }))
}
