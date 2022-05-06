//
//  Inspection.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/6/22.
//

import Foundation
import Combine

final class Inspection<V> {
    let notice = PassthroughSubject<UInt, Never>()
    var callbacks = [UInt: (V) -> Void]()
    
    func visit(_ view: V, _ line: UInt) {
        if let callback = callbacks.removeValue(forKey: line) {
            callback(view)
        }
    }
}
