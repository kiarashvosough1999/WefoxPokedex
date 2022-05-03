//
//  Application.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import UIKit

class Application: UIApplication, AppEnvironmentContainer {
    private lazy var environment = AppEnvironment.bootstrap()
    
    var appEnvironment: AppEnvironment {
        environment
    }
}
