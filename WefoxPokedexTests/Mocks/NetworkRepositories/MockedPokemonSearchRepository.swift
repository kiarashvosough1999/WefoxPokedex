//
//  MockedPokemonSearchRepository.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

import XCTest
import Combine
@testable import WefoxPokedex

// MARK: - PokemonSearchRepository

class MockedPokemonSearchRepository: MockedNetworkRepository, PokemonSearchRepository, Mock {
    
    enum Action: Equatable {
        case getRandomPokemon(randomNumber: Int)
    }
    
    var actions = MockActions<Action>(expected: [])
    
    var pokemoneRespone: Result<PokemonSearchModel, Error> = .failure(MockError.valueNotSet)
    
    func getRandomPokemon(randomNumber: Int) -> AnyPublisher<PokemonSearchModel, Error> {
        switch pokemoneRespone {
        case .success(let model): register(.getRandomPokemon(randomNumber: Int(model.id)))
        default: break
        }
        return pokemoneRespone.publish()
    }
}
