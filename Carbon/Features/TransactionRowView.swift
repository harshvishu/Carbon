//
//  TransactionRowView.swift
//  Carbon
//
//  Created by Harsh on 15/03/24.
//

import SwiftUI
import ComposableArchitecture

struct TransactionRowView: View {
    let store: Transaction
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: store.type.icon)
                .foregroundStyle(.primary)
                .font(.title.weight(.medium))
            
            VStack(alignment: .leading) {
                Text(store._description)
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
            
            VStack(alignment: .trailing) {
                // TODO: Navigation link to CO2 emission page
                HStack(alignment: .top, spacing: 0) {
                    Text("CO").font(.system(size: 9))
                    Text("2").font(.system(size: 5))
                    
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 9))
                }
                .fontWeight(.medium)
                .foregroundStyle(.red)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .contentShape(Capsule())
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .fill(Color.red.opacity(0.2))
                        .stroke(.red.opacity(0.5), lineWidth: 1.0)
                }
                
                Spacer()
            }
        }
        .lineLimit(1)
    }
}

#Preview {
    TransactionRowView(store: Transaction(amount: 200, _description: "flight", type: .debit, category: .electricity, fromAccount: ""))
}
