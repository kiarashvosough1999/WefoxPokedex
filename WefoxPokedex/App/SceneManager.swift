//
//  SceneManager.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import UIKit

final class SceneManager {

    var activityIdentifier: SceneIdentifier? {
        options
            .userActivities
            .compactMap { SceneIdentifier(rawValue: $0.activityType) }
            .first
    }

    private let options: UIScene.ConnectionOptions

    init(with options: UIScene.ConnectionOptions) {
        self.options = options
    }

    func generateUISceneConfiguration() -> UISceneConfiguration {
        let identifier = activityIdentifier ?? .mainApp
        return generateConfig(from: identifier)
    }

    fileprivate func generateConfig(from identifier: SceneIdentifier) -> UISceneConfiguration {
        let config = UISceneConfiguration()
        config.sceneClass = identifier.sceneClass
        config.delegateClass = identifier.delegateClass
        config.storyboard = identifier.storyboard
        return config
    }
}
