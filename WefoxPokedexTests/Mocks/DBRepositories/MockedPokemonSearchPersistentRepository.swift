//
//  MockedPokemonSearchPersistentRepository.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

import XCTest
import Combine
@testable import WefoxPokedex

// MARK: - PokemonSearchPersistentRepository

final class MockedPokemonSearchPersistentRepository: PokemonSearchPersistentRepository, Mock {
    
    enum Action: Equatable {
        case pokemonExist(id: Int32)
        case savePokemon(model: PokemonSearchModel, imageData: Data)
    }
    
    var actions = MockActions<Action>(expected: [])
    
    var pokemonExistResult: Result<Bool, Error> = .failure(MockError.valueNotSet)
    var savePokemonResult: Result<Bool, Error> = .failure(MockError.valueNotSet)
    
    func pokemonExist(with id: Int32) -> AnyPublisher<Bool, Error> {
        switch pokemonExistResult {
        case .success: register(.pokemonExist(id: id))
        default: break
        }
        return pokemonExistResult.publish()
    }
    
    func savePokemon(model: PokemonSearchModel, imageData: Data) -> AnyPublisher<Bool, Error> {
        switch savePokemonResult {
        case .success: register(.savePokemon(model: model, imageData: imageData))
        default: break
        }
        return savePokemonResult.publish()
    }
}
