//
//  DashboardView.swift
//  Carbon
//
//  Created by Harsh on 15/03/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct Dashboard{
    struct State: Equatable {
        var cardsList = CardsList.State(
            cards: IdentifiedArrayOf<Card.State>(
                arrayLiteral: Card.State(
                    name: "Harsh Vishwakarma",
                    amount: 25000,
                    expiry: "03/26",
                    type: .visa,
                    number: "34501676289"
                ),
                Card.State(
                    name: "Rahul Sharma",
                    amount: 35075,
                    expiry: "06/30",
                    type: .visa,
                    number: "89016762345"
                ),
                Card.State(
                    name: "Abhishek Singh",
                    amount: 15000,
                    expiry: "12/25",
                    type: .visa,
                    number: "67689012345"
                )
            )
        )
        
        var transactionsList = TransactionsList.State()
    }
    
    enum Action: Equatable {
        case cardsList(CardsList.Action)
        case transactionsList(TransactionsList.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.cardsList, action: \.cardsList) {
            CardsList()
        }
        
        Scope(state: \.transactionsList, action: \.transactionsList) {
            TransactionsList()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
            case .cardsList:
                return .none
            case .transactionsList:
                return .none
            }
        }
    }
}

struct DashboardView: View {
    let store: StoreOf<Dashboard>
    
    let quickActions: [TransactionCategory] = [.electricity, .fuel(.petrol), .water]
    
    var body: some View {
        
        ScrollViewReader { scroll in
            List {
                // Cards List View
                CardsListView(store: store.scope(state: \.cardsList, action: \.cardsList))
                    .listRowSeparator(.hidden)
                
                Section {
                    ScrollView(.horizontal) {
                        LazyHStack{
                            ForEach(quickActions) { action in
                                Label(action.name, systemImage: action.icon)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(.primary)
                                                .offset(x: 2, y: 2)
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(.background)
                                        }
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(.primary, lineWidth: 1)
                                    )
                                    .scrollTargetLayout()
                            }
                        }
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .listRowSeparator(.hidden)
                } header: {
                    Text("quick actions".uppercased())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .listRowSeparator(.hidden)
                }
                .listSectionSeparator(.hidden)
                
                Section {
                    TransactionsListView(store: store.scope(state: \.transactionsList, action: \.transactionsList))
                } header: {
                    Text("today".uppercased())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .listRowSeparator(.hidden)
                    
                }
                .listSectionSeparator(.hidden)
            }
            .listStyle(.plain)
            .listRowInsets(.none)
        }
        .scrollIndicators(.hidden)
        .zIndex(1)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // TODO: move to scanner
                    @Dependency(\.transactionDatabase.add) var add
                    let transaction = Transaction(amount: 200, _description: "Electricity", type: .debit, category: .electricity)
                    try? add(transaction)
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                        .frame(width: 32, height: 32)
                        .clipped()
                }
                .foregroundStyle(.primary)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink {
                    Text("Profile")
                } label: {
                    HStack {
                        Image(.profilePic)
                            .resizable()
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                        Text("Hi, Harsh")
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    DashboardView(store: StoreOf<Dashboard>(initialState: Dashboard.State(), reducer: {
        Dashboard()
    }))
}
