//
//  CarbonApp.swift
//  Carbon
//
//  Created by Harsh on 15/03/24.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct CarbonApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let root = StoreOf<Root>(initialState: Root.State()) {
        Root()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(store: root)
        }
        .modelContainer(sharedModelContainer)
    }
}
