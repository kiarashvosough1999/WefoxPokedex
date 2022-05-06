//
//  MockedPokemonImageRepository.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

import XCTest
import Combine
@testable import WefoxPokedex

// MARK: - PokemonImageRepository

class MockedPokemonImageRepository: MockedNetworkRepository, PokemonImageRepository, Mock {
    
    enum Action: Equatable {
        case getPokemonImageData(imageName: String)
    }
    
    var actions = MockActions<Action>(expected: [])
    
    var pokemoneImageRespone: Result<Data, Error> = .failure(MockError.valueNotSet)
    
    func getPokemonImageData(imageName: String) -> AnyPublisher<Data, Error> {
        switch pokemoneImageRespone {
        case .success: register(.getPokemonImageData(imageName: imageName))
        default: break
        }
        return pokemoneImageRespone.publish()
    }
}
