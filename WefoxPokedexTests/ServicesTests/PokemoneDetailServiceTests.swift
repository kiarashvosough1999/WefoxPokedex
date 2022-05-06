//
//  PokemoneDetailServiceTests.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

import XCTest
import Combine
@testable import WefoxPokedex

class PokemoneDetailServiceTests: XCTestCase {

    let appState = CurrentValueSubject<AppState, Never>(AppState())
    var mockedPokemoneDetailRepository: MockedPokemoneDetailRepository!

    var subscriptions = Set<AnyCancellable>()
    var sut: PokemoneDetailService!

    override func setUp() {
        appState.value = AppState()
        mockedPokemoneDetailRepository = MockedPokemoneDetailRepository()
        sut = PokemoneDetailServiceImpl(pokemoneDetailRepository: mockedPokemoneDetailRepository,
                                        appState: appState)
    }

    override func tearDown() {
        subscriptions = Set<AnyCancellable>()
    }
    
    // MARK: - Test
    
    func testDetailSuccessful() throws {

        let mockModel = PokemoneDetailModel.mocks.first!

        mockedPokemoneDetailRepository.getPokemoneResult = .success(mockModel)
        mockedPokemoneDetailRepository.actions = .init(expected: [.getPokemone(id: mockModel.id)])
        let exp = XCTestExpectation(description: #function)

        sut.getPokemone(with: mockModel.id)
            .sinkToResult { result in
                result.assertSuccess(value: mockModel)
                self.mockedPokemoneDetailRepository.verify()
                exp.fulfill()
            }
            .store(in: &subscriptions)

        wait(for: [exp], timeout: 2)
    }
    
    func testDetailUnSuccessful() throws {

        let mockModel = PokemoneDetailModel.mocks.first!

        mockedPokemoneDetailRepository.getPokemoneResult = .failure(PersistentError.coreDataError(reason: .CannotFindObject))
        mockedPokemoneDetailRepository.actions = .init(expected: [])
        let exp = XCTestExpectation(description: #function)

        sut.getPokemone(with: mockModel.id)
            .sinkToResult { result in
                result.assertFailure()
                self.mockedPokemoneDetailRepository.verify()
                exp.fulfill()
            }
            .store(in: &subscriptions)

        wait(for: [exp], timeout: 2)
    }
}
