//
//  AppDelegate.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return SceneManager(with: options).generateUISceneConfiguration()
    }
}
