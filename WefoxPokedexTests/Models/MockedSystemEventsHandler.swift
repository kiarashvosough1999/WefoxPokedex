//
//  MockedSystemEventsHandler.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/5/22.
//

import XCTest
import Combine
@testable import WefoxPokedex

// MARK: - SystemEventsHandler

final class MockedSystemEventsHandler: Mock, AppEventsHandler {
    enum Action: Equatable {
        case becomeActive
        case resignActive
    }
    var actions = MockActions<Action>(expected: [])
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    func sceneDidBecomeActive() {
        register(.becomeActive)
    }
    
    func sceneWillResignActive() {
        register(.resignActive)
    }
}
