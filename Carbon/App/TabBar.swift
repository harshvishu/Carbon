//
//  TabBar.swift
//  iOS Example
//
//  Created by Harsh on 13/03/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct TabBarFeature {
    
    @ObservableState
    struct State: Equatable {
        var currentTab = Tab.dashboard
        var dashboard = Dashboard.State()
    }
    
    enum Action: Equatable {
        case selectTab(Tab)
        case dashboard(Dashboard.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.dashboard, action: \.dashboard) {
            Dashboard()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
            case .dashboard:
                return .none
            case .selectTab:
                return .none
            }
        }
    }
}

struct TabBarView: View {
    @Bindable var store: StoreOf<TabBarFeature>
    
    init(store: StoreOf<TabBarFeature>) {
        self.store = store
    }
    
    public var body: some View {
        TabView(selection: .init(get: {
            store.state.currentTab
        }, set: { newTab in
            store.send(.selectTab(newTab))
        }), content:  {
            DashboardView(store: store.scope(state: \.dashboard, action: \.dashboard))
                .hideNativeTabBar()
                .tabItem {
                    Text(Tab.dashboard.title)
                }
                .tag(Tab.dashboard)
        })
        
    }
}

public extension View {
    @ViewBuilder
    func hideNativeTabBar() -> some View {
        self.toolbar(.hidden, for: .tabBar)
    }
}
