//
//  AppState++Permissions.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import Foundation

extension AppState {
    struct Permissions: Equatable {}
}

enum Permission {}

extension Permission {
    enum Status: Equatable {
        case unknown
        case notRequested
        case granted
        case denied
    }
}
