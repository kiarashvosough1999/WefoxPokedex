//
//  PokemonSearchPersistentRepositoryTests.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

import XCTest
import Combine
@testable import WefoxPokedex

class PokemonSearchPersistentRepositoryTests: XCTestCase {
    
    var mockedStore: MockedPersistentStore!
    var sut: PokemonSearchPersistentRepositoryImpl!
    var cancelBag = Cancelables()
    
    override func setUp() {
        mockedStore = MockedPersistentStore()
        sut = PokemonSearchPersistentRepositoryImpl(persistentStore: mockedStore)
        mockedStore.verify()
    }
    
    override func tearDown() {
        cancelBag = Cancelables()
        sut = nil
        mockedStore = nil
    }
    
    // MARK: - Tests
    
    func testPokemonesDoesNotExist() {
        mockedStore.actions = .init(expected: [.count])
        let exp = XCTestExpectation(description: #function)
        mockedStore.countResult = 0
        sut.pokemonExist(with: 23)
            .sinkToResult { result in
                result.assertSuccess(value: false)
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
        wait(for: [exp], timeout: 0.5)
    }
    
    func testPokemonesExist() throws {
        
        let imageData = try XCTUnwrap(TestImage1().pngData)
        
        mockedStore.actions = .init(expected: [.insert(.init(inserted: 1, updated: 0, deleted: 0))])
        let exp = XCTestExpectation(description: #function)
        exp.expectedFulfillmentCount = 2
        mockedStore.countResult = 0
        
        let model: PokemonSearchModel = try XCTUnwrap(.mocks.first)
        
        sut.savePokemon(model: model, imageData: imageData)
            .flatMap { saved -> AnyPublisher<Bool, Error> in
                XCTAssertTrue(saved)
                self.mockedStore.verify()
                self.mockedStore.actions = .init(expected: [.count])
                exp.fulfill()
                return self.sut.pokemonExist(with: model.id)
            }
            .sinkToResult { result in
                result.assertSuccess(value: true)
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
        wait(for: [exp], timeout: 2.5)
    }
}
