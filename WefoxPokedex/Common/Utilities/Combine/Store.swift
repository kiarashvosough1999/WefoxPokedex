//
//  Store.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import Combine

typealias Store<AnyState> = CurrentValueSubject<AnyState, Never>

extension Store {
    
    subscript<T>(keyPath: WritableKeyPath<Output, T>) -> T where T: Equatable {
        get { value[keyPath: keyPath] }
        set {
            var value = self.value
            if value[keyPath: keyPath] != newValue {
                value[keyPath: keyPath] = newValue
                self.value = value
            }
        }
    }
}
