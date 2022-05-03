//
//  Cancelables.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import Combine

final class Cancelables {
    
    fileprivate(set) var subscriptions = Set<AnyCancellable>()
    
    func cancel() {
        subscriptions.removeAll()
    }
    
    func collect(@Builder _ cancellables: () -> [AnyCancellable]) {
        subscriptions.formUnion(cancellables())
    }

    @resultBuilder
    struct Builder {
        static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
            return cancellables
        }
    }
}

extension AnyCancellable {
    
    func store(in cancelBag: Cancelables) {
        cancelBag.subscriptions.insert(self)
    }
}
