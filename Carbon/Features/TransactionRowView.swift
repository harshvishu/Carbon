//
//  TransactionRowView.swift
//  Carbon
//
//  Created by Harsh on 15/03/24.
//

import SwiftUI
import ComposableArchitecture

struct TransactionRowView: View {
    let store: StoreOf<Transaction>
    
    var body: some View {
        HStack {
            Image(systemName: store.type.icon)
                .foregroundStyle(.primary)
                .font(.title3)
            
            VStack(alignment: .leading) {
                Text(store.description)
                    .font(.headline)
                    .padding(.horizontal, 8)
                
                Text(store.category.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("$ \(store.amount, specifier: "%2.2f")")
                    .font(.headline)
                    .padding(.horizontal, 8)
                
                Text(store.date, style: .date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
            }
            VStack {
                Text("CO") + Text("2")
            }
        }
        .lineLimit(1)
    }
}

#Preview {
    TransactionRowView(store: StoreOf<Transaction>(initialState: Transaction.State(amount: 200, description: "flight", type: .debit, category: .electricity), reducer: {
        Transaction()
    }))
}
