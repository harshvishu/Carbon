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
        var transactions: IdentifiedArrayOf<TransactionRow.State> = []
        
        init() {
            @Dependency(\.transactionDatabase.fetchAll) var fetchAll
            do {
                let results = try fetchAll()
                let transactions = results.map({TransactionRow.State(transaction: $0)})
                self.transactions = IdentifiedArray(uniqueElements: transactions)
            } catch {
                print(error)
            }
        }
    }
    
    enum Action: Equatable {
        case transactions(IdentifiedActionOf<TransactionRow>)
    }
    
    var body: some Reducer<State, Action> {
      EmptyReducer()
        .forEach(\.transactions, action: \.transactions) {
            TransactionRow()
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
