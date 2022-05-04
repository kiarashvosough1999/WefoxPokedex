//
//  MainAppSceneDelegate.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import UIKit
import SwiftUI
import Combine
import Foundation

final class MainAppSceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let appEnvironment = self.appEnviroment else {
            return
        }
        
        let contentView = ContentView(viewModel: ContentView.ViewModel(container: appEnvironment.container))
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        appEnviroment?.systemEventsHandler.sceneDidBecomeActive()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        appEnviroment?.systemEventsHandler.sceneWillResignActive()
    }
}
