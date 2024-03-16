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
        } destination: { store in
            switch store.case {
            case let .emissions(store):
                EmissionDetailsView(store: store)
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
