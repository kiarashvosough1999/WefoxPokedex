//
//  SceneIdentifier.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import UIKit

enum SceneIdentifier: String {
    case mainApp
    
    var sceneClass: AnyClass? { nil }

    var delegateClass: AnyClass? {
        switch self {
        case .mainApp:
            return MainAppSceneDelegate.self
        }
    }

    var storyboard: UIStoryboard? { nil }
}
