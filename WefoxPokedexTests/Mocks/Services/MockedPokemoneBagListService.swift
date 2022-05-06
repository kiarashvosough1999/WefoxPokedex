//
//  MockedPokemoneBagListService.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

@testable import WefoxPokedex
import Combine
import Foundation

struct MockedPokemoneBagListService: Mock, PokemoneBagListService {

    enum Action: Equatable {
        case observePokemonesBag
    }
    
    let actions: MockActions<Action>
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    var observePokemonesBagResponse: Result<[PokemonBagListModel], Error> = .failure(MockError.valueNotSet)
    
    func observePokemonesBag() -> AnyPublisher<[PokemonBagListModel], Error> {
        switch observePokemonesBagResponse {
        case .success: register(.observePokemonesBag)
        default: break
        }
        return observePokemonesBagResponse.publish()
    }
}
