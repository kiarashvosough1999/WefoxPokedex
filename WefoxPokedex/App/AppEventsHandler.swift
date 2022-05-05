//
//  AppEventsHandler.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import UIKit
import Combine

protocol AppEventsHandler {
    func sceneDidBecomeActive()
    func sceneWillResignActive()
}

struct AppEventsHandlerImpl: AppEventsHandler {
    
    let container: DIContainer
    private var cancelBag = Cancelables()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func sceneDidBecomeActive() {
        container.appState[\.system.isActive] = true
    }
    
    func sceneWillResignActive() {
        container.appState[\.system.isActive] = false
    }
}
