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
    
    @ObservableState
    struct State: Equatable {
        var tabs = TabBarFeature.State()
    }
    
    enum Action: Equatable {
        case tabs(TabBarFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        
        Scope(state: \.tabs, action: \.tabs) {
            TabBarFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .tabs:
                return .none
            }
        }
    }
}

struct RootView: View {
    @Environment(SceneDelegate.self) var sceneDelegate
    @Bindable var store: StoreOf<Root>
    
    var body: some View {
        TabBarView(store: store.scope(state: \.tabs, action: \.tabs))
            .task {
                initializeCustomTabBar()
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
