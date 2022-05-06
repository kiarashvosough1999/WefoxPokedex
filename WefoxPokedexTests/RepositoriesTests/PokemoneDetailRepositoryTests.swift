//
//  PokemoneDetailRepositoryTests.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

import XCTest
import Combine
@testable import WefoxPokedex

class PokemoneDetailRepositoryTests: XCTestCase {
    
    var mockedStore: MockedPersistentStore!
    var sut: PokemoneDetailRepositoryImpl!
    var sutIntegrated: PokemonSearchPersistentRepositoryImpl!
    var cancelBag = Cancelables()
    
    override func setUp() {
        mockedStore = MockedPersistentStore()
        sut = PokemoneDetailRepositoryImpl(persistentStore: mockedStore)
        sutIntegrated = PokemonSearchPersistentRepositoryImpl(persistentStore: mockedStore)
        mockedStore.verify()
    }
    
    override func tearDown() {
        cancelBag = Cancelables()
        sut = nil
        mockedStore = nil
    }
    
    // MARK: - Tests
    
    func testPokemonesDoesNotExist() {
        let exp = XCTestExpectation(description: #function)
        let id: Int32 = 32
        sut.getPokemone(with: id)
            .sinkToResult { result in
                result.assertFailure()
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

        sutIntegrated.savePokemon(model: model, imageData: imageData)
            .flatMap { saved -> AnyPublisher<PokemoneDetailModel, Error> in
                XCTAssertTrue(saved)
                self.mockedStore.verify()
                self.mockedStore.actions = .init(expected: [.fetchOne(.init(inserted: 0, updated: 0, deleted: 0))])
                exp.fulfill()
                return self.sut.getPokemone(with: model.id)
            }
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let failure): XCTFail("Test failed in\(#file) at line \(#line) due to \(failure)")
                }
            } receiveValue: { value in
                XCTAssertEqual(model.baseExperience, value.baseExperience)
                XCTAssertEqual(model.height, value.height)
                XCTAssertEqual(model.id, value.id)
                XCTAssertEqual(model.name, value.name)
                XCTAssertEqual(model.types.joined(separator: ","), value.types)
                XCTAssertEqual(model.weight, value.weight)

                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
        wait(for: [exp], timeout: 2.5)
    }
}
