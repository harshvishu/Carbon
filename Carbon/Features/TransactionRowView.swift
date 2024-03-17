//
//  TransactionRowView.swift
//  Carbon
//
//  Created by Harsh on 15/03/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct TransactionRow {
    
    @ObservableState
    struct State: Equatable, Identifiable {
        var id: ObjectIdentifier {
            transaction.id
        }
        var transaction: Transaction
    }
    
    enum Action: Equatable {
        case emissionsButtonTapped
        case emissionsFetched(Emissions)
        
        case delegate(Delegate)
        enum Delegate: Equatable {
            case showEmissions(Emissions)
            case showTransactionDetails(Transaction)
            case emissionsFetchError
        }
    }
    
    @Dependency(\.climateAPIClient) var climateAPIClient
    
    var body: some ReducerOf<Self>{
        Reduce<State, Action> { state, action in
            switch action {
            case .emissionsButtonTapped:
                if let emissions = state.transaction.emissions {
                    return .send(.delegate(.showEmissions(emissions)))
                } else {
                    return .run { [state = state] send in
                        // TODO: use real data
                        let result = try await climateAPIClient.estimate(query: state.transaction.category.query(money: state.transaction.amount))
                        guard result.co2E != nil else {return await send(.delegate(.emissionsFetchError))}
                        await send(.emissionsFetched(result))
                        await send(.delegate(.showEmissions(result)))
                    }
                }
            case let .emissionsFetched(emissions):
                return .run {@MainActor [state = state] send in
                    state.transaction.emissions = emissions
                }
            case .delegate:
                return .none
            }
        }
    }
}

struct TransactionRowView: View {
    @Dependency(\.climateAPIClient) var climateAPIClient
    
    let store: StoreOf<TransactionRow>
    
    var body: some View {
        NavigationLink(state: Root.Path.State.transactionDetails(TransactionDetail.State(transaction: store.transaction))) {
            HStack(alignment: .center) {
                Image(systemName: store.transaction.type.icon)
                    .font(.title.weight(.medium))
                    .symbolVariant(.fill.circle)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(store.transaction.type == .credit ? .green : .red)
                
                VStack(alignment: .leading) {
                    Text(store.transaction._description)
                        .font(.headline)
                        .padding(.horizontal, 8)
                    
                    Text(store.transaction.category.name)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("₹ \(store.transaction.amount, specifier: "%2.2f")")
                        .font(.headline)
                        .padding(.horizontal, 8)
                    
                    Text(store.transaction.date, style: .date)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                }
                
                VStack(alignment: .trailing) {
                    // TODO: Navigation link to CO2 emission page
                    Button {
                        store.send(.emissionsButtonTapped)
                    } label: {
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
                    }
                    .buttonStyle(.plain)
                    
                    
                    Group {
//                        Text(store.transaction.emissions?.co2E ?? 0.0, format: .number.precision(.fractionLength(2)))
//                        + Text(store.transaction.emissions?.co2EUnit ?? "")
                        
                        Image(systemName: "leaf.fill")
                    }
                    .font(.system(size: 9))
                    .fontWeight(.medium)
                    .foregroundStyle(.green)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .opacity(store.transaction.category.isGreen ? 1 : 0)
                }
                .frame(alignment: .topTrailing)
            }
            .lineLimit(1)
        }
    }
}

#Preview {
    TransactionRowView(store: StoreOf<TransactionRow>(initialState: TransactionRow.State(transaction: Transaction(amount: 200, _description: "flight", type: .debit, category: .electricity, fromAccount: "")), reducer: {
        TransactionRow()
    }))
}
