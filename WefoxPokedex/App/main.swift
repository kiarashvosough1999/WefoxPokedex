//
//  main.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import UIKit

/// Avoids calls for AppDelegate in UnitTest.
private func delegateClassName() -> String? {
    return NSClassFromString("XCTestCase") == nil ? NSStringFromClass(AppDelegate.self) : nil
}

let argc = CommandLine.argc
let argv = CommandLine.unsafeArgv
  _ = UIApplicationMain(argc, argv, NSStringFromClass(Application.self), delegateClassName())
