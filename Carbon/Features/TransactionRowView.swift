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
                        let result = try await climateAPIClient.estimate(query: .init(emission_factor: .init(activity_id: state.transaction.category.activity_id), parameters: .init(energy: 200, energy_unit: .kWh)))
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
        HStack(alignment: .center) {
            Image(systemName: store.transaction.type.icon)
                .foregroundStyle(.primary)
                .font(.title.weight(.medium))
            
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
                Text("$ \(store.transaction.amount, specifier: "%2.2f")")
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
                
                Spacer()
            }
//            .onTapGesture {
//                // TODO: If data exists navigate to emissions page or call the api then navigate
//                Task {
//                    do {
//                        let result = try await climateAPIClient.estimate(query: .init(emission_factor: .init(activity_id: store.transaction.category.activity_id), parameters: .init(energy: 200, energy_unit: .kWh)))
//                        dump(result)
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
        }
        .lineLimit(1)
    }
}

#Preview {
    TransactionRowView(store: StoreOf<TransactionRow>(initialState: TransactionRow.State(transaction: Transaction(amount: 200, _description: "flight", type: .debit, category: .electricity, fromAccount: "")), reducer: {
        TransactionRow()
    }))
}
