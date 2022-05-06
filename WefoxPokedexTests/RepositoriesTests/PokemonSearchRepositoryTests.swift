//
//  PokemonSearchRepositoryTests.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

import XCTest
import Combine
@testable import WefoxPokedex

final class PokemonSearchRepositoryTests: XCTestCase {
    
    private var sut: PokemonSearchRepositoryImpl!
    private var subscriptions = Set<AnyCancellable>()
    
    typealias API = PokemonSearchRepositoryImpl.API
    typealias Mock = RequestMocking.MockedResponse
    
    override func setUp() {
        subscriptions = Set<AnyCancellable>()
        sut = PokemonSearchRepositoryImpl(session: .mockedResponsesOnly,
                                          baseURL: "https://test.com")
    }
    
    override func tearDown() {
        RequestMocking.removeAllMocks()
    }
    
    private func mock<T>(_ apiCall: API,
                         result: Result<T, Swift.Error>,
                         httpCode: HTTPStatusCode = 200) throws where T: Encodable {
        let mock = try Mock(apiCall: apiCall, baseURL: sut.baseURL, result: result, httpCode: httpCode)
        RequestMocking.add(mock: mock)
    }
    
    // MARK: - Tests
    
    func testRandomPokemon() throws {
        let data = PokemonAPISearchModel.mocks.first!
        let fakeRandomId = Int(data.id)
        try mock(.random(number: fakeRandomId), result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        
        sut.getRandomPokemon(randomNumber: fakeRandomId)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let failure): XCTFail("Test failed in\(#file) at line \(#line) due to \(failure)")
                }
            } receiveValue: { model in
                XCTAssertEqual(model.baseExperience, data.baseExperience)
                XCTAssertEqual(model.height, data.height)
                XCTAssertEqual(model.id, data.id)
                XCTAssertEqual(model.name, data.name)
                XCTAssertEqual(model.order, data.order)
                XCTAssertEqual(model.frontDefault, data.sprites.frontDefault)
                XCTAssertEqual(model.types,data.types.map(\.type.name))
                XCTAssertEqual(model.weight, data.weight)
                exp.fulfill()
            }
            .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
}
