//
//  CustomTabBar.swift
//  Carbon
//
//  Created by Harsh on 15/03/24.
//

import SwiftUI
import ComposableArchitecture

struct CustomTabBar: View {
    @Bindable var store: StoreOf<TabBarFeature>
    
    init(store: StoreOf<TabBarFeature>) {
        self.store = store
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(Tab.allCases) { tab in
                    Button( action: {
                        store.send(.selectTab(tab))
                    }, label: {
                        VStack {
                            tab.image
                                .frame(width: 55, height: 55)
                        }
                        .foregroundStyle(store.state.currentTab == tab ? .white : .gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(.rect)
                    })
                }
            }
            .frame(height: showTabBar ? 55.0 : .zero)
        }
        .background(
            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 15, bottomLeading: 0, bottomTrailing: 0, topTrailing: 15))
                .stroke(.tertiary, lineWidth: 1)
                .fill(.black)
                .ignoresSafeArea(.all)
                .shadow(color: .secondary.opacity(0.1), radius: 20, x: 0.0, y: 2.0)
        )
        .opacity(showTabBar ? 1 : 0)
        .offset(y: showTabBar ? .zero : 55.0)
        .transition(.slide)
        .animation(.default, value: showTabBar)
    }
    
    private var showTabBar: Bool {
        true
    }
}

#Preview {
    CustomTabBar(store: StoreOf<TabBarFeature>(initialState: TabBarFeature.State(), reducer: {
        TabBarFeature()
    }))
}
