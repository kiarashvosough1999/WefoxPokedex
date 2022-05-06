//
//  MockedPokemoneDetailService.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

@testable import WefoxPokedex
import Combine
import Foundation

struct MockedPokemoneDetailService: Mock, PokemoneDetailService {

    enum Action: Equatable {
        case getPokemone(id: Int32)
    }
    
    let actions: MockActions<Action>
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    var getPokemoneResponse: Result<PokemoneDetailModel, Error> = .failure(MockError.valueNotSet)
    
    func getPokemone(with id: Int32) -> AnyPublisher<PokemoneDetailModel, Error> {
        switch getPokemoneResponse {
        case .success: register(.getPokemone(id: id))
        default: break
        }
        return getPokemoneResponse.publish()
    }
}
