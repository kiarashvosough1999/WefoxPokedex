//
//  UIResponder++Extensions.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import UIKit

extension UIResponder {
    var appEnviroment: AppEnvironment? {
        (UIApplication.shared as? Application)?.appEnvironment
    }
}
