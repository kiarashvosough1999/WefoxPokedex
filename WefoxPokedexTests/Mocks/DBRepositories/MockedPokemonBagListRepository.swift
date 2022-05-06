//
//  MockedPokemonSearchRepository.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//


import XCTest
import Combine
@testable import WefoxPokedex

// MARK: - PokemonBagListRepository

final class MockedPokemonBagListRepository: PokemonBagListRepository, Mock {
  
    enum Action: Equatable {
        case objectPublisherForPokemonBag(keyPath: String, ascending: Bool)
    }
    
    var actions = MockActions<Action>(expected: [])
    
    var objectPublisherForPokemonBag: Result<[PokemonBagListModel], Error> = .failure(MockError.valueNotSet)
    
    func objectPublisherForPokemonBag(sortedBy keyPath: String, ascending: Bool) -> AnyPublisher<[PokemonBagListModel], Error> {
        switch objectPublisherForPokemonBag {
        case .success: register(.objectPublisherForPokemonBag(keyPath: keyPath, ascending: ascending))
        default: break
        }
        return objectPublisherForPokemonBag.publish()
    }
}
