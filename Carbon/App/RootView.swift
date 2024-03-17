//
//  RootView.swift
//  iOS Example
//
//  Created by Harsh on 13/03/24.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@Reducer
struct Root {
    @Reducer(state: .equatable)
    enum Path {
        case emissions(EmissionDetails)  // TODO: Need a State
        case transactionDetails(TransactionDetail)
    }
    
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var tabs = TabBarFeature.State()
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case tabs(TabBarFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        
        Scope(state: \.tabs, action: \.tabs) {
            TabBarFeature()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
            case .path:
                return .none
            case let .tabs(.dashboard(.transactionsList(.transactions(.element(id: _, action: .delegate(.showEmissions(emissions))))))):
                state.path.append(.emissions(EmissionDetails.State(emissions: emissions)))
                return .none
            case .tabs:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

struct RootView: View {
    @Environment(SceneDelegate.self) var sceneDelegate
    @Bindable var store: StoreOf<Root>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            TabBarView(store: store.scope(state: \.tabs, action: \.tabs))
                .task {
                    initializeCustomTabBar()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            // TODO: move to scanner
//                            @Dependency(\.transactionDatabase.add) var add
//                            let category: TransactionCategory = .domesticFlight
//                            let transaction = Transaction(
//                                amount: 10000,
//                                _description: category.name,
//                                type: .debit,
//                                category: category
//                            )
//                            try? add(transaction)
                        } label: {
                            Image(systemName: "bell.badge")
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
                .toolbar(store.tabs.currentTab == .dashboard ? .visible : .hidden, for: .navigationBar)
        } destination: { store in
            switch store.case {
            case let .emissions(store):
                EmissionDetailsView(store: store)
            case let .transactionDetails(store: store):
                TransactionDetailsView(store: store)
            }
        }
    }
}


extension RootView {
    fileprivate func initializeCustomTabBar() {
        guard sceneDelegate.tabWindow == nil else {return}
        sceneDelegate.addTabBar(store: store.scope(state: \.tabs, action: \.tabs))
    }
}


#Preview {
    RootView(store: StoreOf<Root>(initialState: Root.State(), reducer: {
        Root()
    }))
    .environment(SceneDelegate())
}
