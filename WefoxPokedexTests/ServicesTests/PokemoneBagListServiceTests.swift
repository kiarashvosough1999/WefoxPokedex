//
//  PokemoneBagListServiceTests.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

import XCTest
import Combine
@testable import WefoxPokedex

class PokemoneBagListServiceTests: XCTestCase {

    let appState = CurrentValueSubject<AppState, Never>(AppState())
    var pokemonBagListRepository: MockedPokemonBagListRepository!

    var subscriptions = Set<AnyCancellable>()
    var sut: PokemoneBagListService!

    override func setUp() {
        appState.value = AppState()
        pokemonBagListRepository = MockedPokemonBagListRepository()
        sut = PokemoneBagListServiceImpl(pokemonBagListRepository: pokemonBagListRepository,
                                         appState: appState)
    }

    override func tearDown() {
        subscriptions = Set<AnyCancellable>()
    }
    
    // MARK: - Test
    
    func testEmptyBag() throws {
        pokemonBagListRepository.objectPublisherForPokemonBag = .success([])
        pokemonBagListRepository.actions = .init(expected: [.objectPublisherForPokemonBag(keyPath: "order", ascending: true)])
        let exp = XCTestExpectation(description: #function)
        
        sut.observePokemonesBag().sinkToResult { result in
            result.assertSuccess(value: [])
            self.pokemonBagListRepository.verify()
            exp.fulfill()
        }
        .store(in: &subscriptions)
        
        wait(for: [exp], timeout: 2)
    }
    
    func testNotEmptyBag() throws {
        pokemonBagListRepository.objectPublisherForPokemonBag = .success(PokemonBagListModel.mocks)
        pokemonBagListRepository.actions = .init(expected: [.objectPublisherForPokemonBag(keyPath: "order", ascending: true)])
        let exp = XCTestExpectation(description: #function)
        
        sut.observePokemonesBag().sinkToResult { result in
            result.assertSuccess(value: PokemonBagListModel.mocks)
            self.pokemonBagListRepository.verify()
            exp.fulfill()
        }
        .store(in: &subscriptions)
        
        wait(for: [exp], timeout: 2)
    }
    
    func testErrorFetchingBag() throws {
        pokemonBagListRepository.objectPublisherForPokemonBag = .failure(PersistentError.coreDataError(reason: .CannotFetch))
        pokemonBagListRepository.actions = .init(expected: [])
        let exp = XCTestExpectation(description: #function)
        
        sut.observePokemonesBag().sinkToResult { result in
            result.assertFailure()
            self.pokemonBagListRepository.verify()
            exp.fulfill()
        }
        .store(in: &subscriptions)
        
        wait(for: [exp], timeout: 2)
    }
}
