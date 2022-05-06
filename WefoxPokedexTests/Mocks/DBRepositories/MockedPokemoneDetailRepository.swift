//
//  MockedPokemoneDetailRepository.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

import XCTest
import Combine
@testable import WefoxPokedex

// MARK: - PokemoneDetailRepository

final class MockedPokemoneDetailRepository: PokemoneDetailRepository, Mock {
  
    enum Action: Equatable {
        case getPokemone(id: Int32)
    }
    
    var actions = MockActions<Action>(expected: [])
    
    var getPokemoneResult: Result<PokemoneDetailModel, Error> = .failure(MockError.valueNotSet)
    
    func getPokemone(with id: Int32) -> AnyPublisher<PokemoneDetailModel, Error> {
        switch getPokemoneResult {
        case .success: register(.getPokemone(id: id))
        default: break
        }
        return getPokemoneResult.publish()
    }
}
