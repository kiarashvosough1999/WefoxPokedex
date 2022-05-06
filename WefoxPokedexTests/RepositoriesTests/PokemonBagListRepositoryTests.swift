//
//  PokemonBagListRepositoryTests.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

import XCTest
import Combine
@testable import WefoxPokedex

class PokemonBagListRepositoryTests: XCTestCase {
    
    var mockedStore: MockedPersistentStore!
    var sut: PokemonBagListRepositoryImpl!
    var sutIntegrated: PokemonSearchPersistentRepositoryImpl!
    var cancelBag = Cancelables()
    
    override func setUp() {
        mockedStore = MockedPersistentStore()
        sut = PokemonBagListRepositoryImpl(persistentStore: mockedStore)
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
        mockedStore.actions = .init(expected: [.objectPublisher(publishedObjectCount: 0)])
        let exp = XCTestExpectation(description: #function)
        sut.objectPublisherForPokemonBag(sortedBy: "order", ascending: true)
            .sinkToResult { result in
                result.assertSuccess(value: [])
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
        
        sutIntegrated.savePokemon(model: model, imageData: imageData)
            .flatMap { saved -> AnyPublisher<[PokemonBagListModel], Error> in
                XCTAssertTrue(saved)
                self.mockedStore.verify()
                self.mockedStore.actions = .init(expected: [.objectPublisher(publishedObjectCount: 1)])
                exp.fulfill()
                return self.sut.objectPublisherForPokemonBag(sortedBy: "order", ascending: true)
            }
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let failure): XCTFail("Test failed in\(#file) at line \(#line) due to \(failure)")
                }
            } receiveValue: { values in
                let firstValue = values.first!
                XCTAssertNotNil(firstValue)
                
                XCTAssertEqual(model.baseExperience, firstValue.baseExperience)
                XCTAssertEqual(model.height, firstValue.height)
                XCTAssertEqual(model.id, firstValue.id)
                XCTAssertEqual(model.name, firstValue.name)
                XCTAssertEqual(model.order, firstValue.order)
                XCTAssertEqual(model.types.joined(separator: ","),firstValue.types)
                XCTAssertEqual(model.weight, firstValue.weight)
                
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
        wait(for: [exp], timeout: 2.5)
    }
}
