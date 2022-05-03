//
//  AppEnvironment.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import Foundation

protocol AppEnvironmentContainer {
    var appEnvironment: AppEnvironment { get }
}

struct AppEnvironment {
    let container: DIContainer
    let systemEventsHandler: AppEventsHandler
}

extension AppEnvironment {
    static func bootstrap() -> AppEnvironment {
        let appState = Store<AppState>(AppState())
        
        // configuring Services
        let services = configuredServices()
        
        // configuring DIContainer
        let diContainer = DIContainer(appState: appState, services: services)
        
        // configuring AppEventsHandler
        let systemEventsHandler = AppEventsHandlerImpl(container: diContainer)

        return AppEnvironment(container: diContainer,
                              systemEventsHandler: systemEventsHandler)
    }
    
    private static func configuredServices() -> DIContainer.Services {
        return DIContainer.Services()
    }
}
