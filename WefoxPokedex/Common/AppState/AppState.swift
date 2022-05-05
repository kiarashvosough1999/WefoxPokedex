//
//  AppState.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import Foundation

import SwiftUI
import Combine

struct AppState: Equatable {
    
    var userData = UserData()
    var routing = ViewRouting()
    var system = System()
    
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        return lhs.userData == rhs.userData &&
            lhs.routing == rhs.routing &&
            lhs.system == rhs.system
    }
}

#if DEBUG
extension AppState {
    static var preview: AppState {
        var state = AppState()
        state.system.isActive = true
        return state
    }
}
#endif
