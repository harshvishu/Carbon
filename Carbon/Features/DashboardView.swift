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
        
        var transactionsList = TransactionsList.State(
            transactions: IdentifiedArrayOf<Transaction.State>(
                arrayLiteral: Transaction.State(
                    amount: 1200,
                    description: "Electricity Bill",
                    type: .debit,
                    category: .electricity
                ),
                Transaction.State(
                    amount: 5000,
                    description: "petrol",
                    type: .debit,
                    category: .fuel(.petrol)
                ),
                Transaction.State(
                    amount: 200,
                    description: "Water Bill",
                    type: .debit,
                    category: .water
                )
            )
        )
    }
    
    enum Action: Equatable {
        case cardsList(CardsList.Action)
        case transactionsList(TransactionsList.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.cardsList, action: \.cardsList) {
            CardsList()
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
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scroll in
                ScrollView(.vertical) {
                    // Cards List View
                    CardsListView(store: store.scope(state: \.cardsList, action: \.cardsList))
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("quick actions".uppercased())
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ScrollView(.horizontal) {
                            LazyHStack{
                                ForEach(1...10, id: \.self) { count in
                                    Label("Action", systemImage: "\(count).square.fill")
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .border(Color.black, width: 1)
                                        .scrollTargetLayout()
                                }
                            }
                        }
                        .scrollTargetBehavior(.viewAligned)
                        
                        LazyVStack(alignment: .leading, spacing: 20) {
                            Text("today".uppercased())
                                .font(.footnote)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            TransactionsListView(store: store.scope(state: \.transactionsList, action: \.transactionsList))
                        }
                    }
                    .padding(.top)
                    .padding(.horizontal)
                }
            }
            .scrollIndicators(.hidden)
            .zIndex(1)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        Text("Carbon")
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                            .frame(width: 32, height: 32)
                            .clipped()
                    }
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
}

#Preview {
    DashboardView(store: StoreOf<Dashboard>(initialState: Dashboard.State(), reducer: {
        Dashboard()
    }))
}
