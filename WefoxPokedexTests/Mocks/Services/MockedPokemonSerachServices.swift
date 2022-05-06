//
//  MockedPokemonSerachServices.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

@testable import WefoxPokedex
import Combine
import Foundation

struct MockedPokemonSerachServices: Mock, PokemonSerachServices {

    enum Action: Equatable {
        case getRandomPokemon
        case savePokemon(model: PokemonSearchModel)
    }
    
    let actions: MockActions<Action>
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    var getRandomPokemonResponse: Result<PokemonSearchResult, Error> = .failure(MockError.valueNotSet)
    var savePokemonResponse: Result<Bool, Error> = .failure(MockError.valueNotSet)
    
    func getRandomPokemon() -> AnyPublisher<PokemonSearchResult, Error> {
        switch getRandomPokemonResponse {
        case .success: register(.getRandomPokemon)
        default: break
        }
        return getRandomPokemonResponse.publish()
    }
    
    func savePokemon(model: PokemonSearchModel) -> AnyPublisher<Bool, Error> {
        switch savePokemonResponse {
        case .success: register(.savePokemon(model: model))
        default: break
        }
        return savePokemonResponse.publish()
    }
}
