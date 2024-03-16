//
//  CardView.swift
//  iOS Example
//
//  Created by Harsh on 13/03/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct CardView: View {
    let store: StoreOf<Card>
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(store.type.rawValue.uppercased())
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.bottom, 5)
                    .frame(alignment: .leading)
            }
            
            Text(store.name)
                .font(.body)
                .padding(.top)
            Text("$\(String(format: "%.2f", store.amount))")
                .font(.title.bold())
                .padding(.bottom)
            
            Text(obfuscateNumber(store.number))
                .font(.body)
        }
        .lineLimit(1)
//        .frame(width: 170, height: 200)
        .aspectRatio(1.7, contentMode: .fit)
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        
    }
    
    // Function to obfuscate number (showing only first character)
    private func obfuscateNumber(_ number: String) -> String {
        let firstCharacter = number.prefix(4)
        let obfuscatedPart = String(repeating: "*", count: number.count - 4)
        return "\(firstCharacter)\(obfuscatedPart)"
    }
}

#Preview {
    CardView(store: StoreOf<Card>(initialState: Card.State(name: "Harsh Vishwakarma", amount: 25000, expiry: "06/12", type: .visa, number: "123 456 7890"), reducer: {
        Card()
    }))
}
