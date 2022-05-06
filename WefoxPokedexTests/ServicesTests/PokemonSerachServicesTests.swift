//
//  PokemonSerachServicesTests.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

import XCTest
import Combine
@testable import WefoxPokedex

class PokemonSerachServicesTests: XCTestCase {

    let appState = CurrentValueSubject<AppState, Never>(AppState())
    var pokemonSearchRepository: MockedPokemonSearchRepository!
    var pokemonSearchPersistentRepository: MockedPokemonSearchPersistentRepository!
    var pokemonImageRepository: MockedPokemonImageRepository!

    var subscriptions = Set<AnyCancellable>()
    var sut: PokemonSerachServices!

    override func setUp() {
        appState.value = AppState()
        pokemonSearchRepository = MockedPokemonSearchRepository()
        pokemonSearchPersistentRepository = MockedPokemonSearchPersistentRepository()
        pokemonImageRepository = MockedPokemonImageRepository()
        sut = PokemonSerachServicesImpl(pokemonSearchRepository: pokemonSearchRepository,
                                        pokemonSearchPersistentRepository: pokemonSearchPersistentRepository,
                                        pokemonImageRepository: pokemonImageRepository,
                                        appState: appState)
    }

    override func tearDown() {
        subscriptions = Set<AnyCancellable>()
    }
    
    // MARK: - Test
    
    func testGetRandomPokemonNotCatchedBefore() throws {
        
        let mockModel = PokemonSearchModel.mocks.first!
        
        pokemonSearchRepository.pokemoneRespone = .success(mockModel)
        pokemonSearchPersistentRepository.pokemonExistResult = .success(false)
        self.pokemonSearchRepository.actions = .init(expected: [.getRandomPokemon(randomNumber: Int(mockModel.id))])
        self.pokemonSearchPersistentRepository.actions = .init(expected: [.pokemonExist(id: mockModel.id)])
        
        let exp = XCTestExpectation(description: #function)
        
        sut.getRandomPokemon().sinkToResult { result in
            result.assertSuccess(value: .new(model: mockModel))
            self.pokemonSearchPersistentRepository.verify()
            self.pokemonSearchRepository.verify()
            exp.fulfill()
        }
        .store(in: &subscriptions)
        
        wait(for: [exp], timeout: 2)
    }
    
    func testGetRandomPokemonCatchedBefore() throws {
        
        let mockModel = PokemonSearchModel.mocks.first!
        
        pokemonSearchRepository.pokemoneRespone = .success(mockModel)
        pokemonSearchPersistentRepository.pokemonExistResult = .success(true)
        self.pokemonSearchRepository.actions = .init(expected: [.getRandomPokemon(randomNumber: Int(mockModel.id))])
        self.pokemonSearchPersistentRepository.actions = .init(expected: [.pokemonExist(id: mockModel.id)])
        
        let exp = XCTestExpectation(description: #function)
        
        sut.getRandomPokemon().sinkToResult { result in
            result.assertSuccess(value: .alreadyPicked(model: mockModel))
            self.pokemonSearchPersistentRepository.verify()
            self.pokemonSearchRepository.verify()
            exp.fulfill()
        }
        .store(in: &subscriptions)
        
        wait(for: [exp], timeout: 2)
    }
    
    func testSavePokemonWithImage() throws {
        let mockModel = PokemonSearchModel.mocks.first!
        let testImage: TesableImage = TestImage1()
        let imageData = try XCTUnwrap(testImage.pngData)
        
        XCTAssertNotNil(imageData)
        
        pokemonSearchPersistentRepository.actions = .init(expected: [.savePokemon(model: mockModel, imageData: imageData)])
        pokemonImageRepository.actions = .init(expected: [.getPokemonImageData(imageName: mockModel.imageURL!.lastPathComponent)])
        
        pokemonSearchPersistentRepository.savePokemonResult = .success(true)
        pokemonImageRepository.pokemoneImageRespone = .success(imageData)
        
        let exp = XCTestExpectation(description: #function)
        
        sut.savePokemon(model: mockModel).sinkToResult { result in
            result.assertSuccess(value: true)
            self.pokemonSearchPersistentRepository.verify()
            self.pokemonImageRepository.verify()
            exp.fulfill()
        }
        .store(in: &subscriptions)
        
        wait(for: [exp], timeout: 2)
    }
    
    func testSavePokemonWithoutImage() throws {
        let mockModel = PokemonSearchModel.mocksWithoutImageURL.first!
        
        pokemonSearchPersistentRepository.actions = .init(expected: [.savePokemon(model: mockModel, imageData: Data())])
        pokemonImageRepository.actions = .init(expected: [])
        
        pokemonSearchPersistentRepository.savePokemonResult = .success(true)
        
        let exp = XCTestExpectation(description: #function)
        
        sut.savePokemon(model: mockModel).sinkToResult { result in
            result.assertSuccess(value: true)
            self.pokemonSearchPersistentRepository.verify()
            self.pokemonImageRepository.verify()
            exp.fulfill()
        }
        .store(in: &subscriptions)
        
        wait(for: [exp], timeout: 2)
    }
}
