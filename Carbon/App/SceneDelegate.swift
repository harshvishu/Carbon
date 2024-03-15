//
//  SceneDelegate.swift
//  iOS Example
//
//  Created by Harsh on 13/03/24.
//

import UIKit
import SwiftUI
import ComposableArchitecture

// MARK: Scene Delegate
@Observable
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    weak var windowScene: UIWindowScene?
    var tabWindow: UIWindow?
    var popWindow: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        windowScene = scene as? UIWindowScene
    }
    
    func addTabBar(
        store: StoreOf<TabBarFeature>
    ) {
        guard let scene = windowScene else {return}

        let tabBarController = UIHostingController(
            rootView:
                CustomTabBar(store: store)
                .frame(maxHeight: .infinity, alignment: .bottom)
        )
        tabBarController.view.backgroundColor = .clear
        
        let tabWindow = PassThroughWindow(windowScene: scene)
        tabWindow.rootViewController = tabBarController
        tabWindow.isHidden = false
        self.tabWindow = tabWindow
    }
}

