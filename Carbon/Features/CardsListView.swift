//
//  CardsListView.swift
//  iOS Example
//
//  Created by Harsh on 13/03/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
struct CardsList {
    @ObservableState
    struct State: Equatable {
        var cards: IdentifiedArrayOf<Card.State> = []
    }
    
    enum Action: Equatable {
        case cards(IdentifiedActionOf<Card>)
    }
    
    var body: some Reducer<State, Action> {
      EmptyReducer()
        .forEach(\.cards, action: \.cards) {
          Card()
        }
    }
}

struct CardsListView: View {
    let store: StoreOf<CardsList>
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(content: {
                ForEach(store.scope(state: \.cards, action: \.cards)) {
                    CardView(store: $0)
                }
            })
        }
        .frame(height: 200)
    }
}

#Preview {
    CardsListView(store: StoreOf<CardsList>(initialState: CardsList.State(), reducer: {
        CardsList()
    }))
}
