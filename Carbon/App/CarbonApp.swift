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
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
           
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView(store: root)
        }
        .modelContainer(sharedModelContainer)
    }
}
