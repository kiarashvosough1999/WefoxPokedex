//
//  NSSet++Extensions.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import Foundation

extension NSSet {
    func toArray<T>(of type: T.Type) -> [T] {
        allObjects.compactMap { $0 as? T }
    }
}
