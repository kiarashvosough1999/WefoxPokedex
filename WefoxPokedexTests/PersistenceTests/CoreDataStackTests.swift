//
//  CoreDataStackTests.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/5/22.
//

import XCTest
@testable import WefoxPokedex

class CoreDataStackTests: XCTestCase {
    
    var sut: CoreDataStack!
    let testDirectory: FileManager.SearchPathDirectory = .cachesDirectory
    var dbVersion: UInt { fatalError("Override In Test") }
    var cancelBag = Cancelables()
    
    override func setUp() {
        eraseDBFiles()
        sut = CoreDataStack(directory: testDirectory, version: dbVersion)
    }
    
    override func tearDown() {
        cancelBag = Cancelables()
        sut = nil
        eraseDBFiles()
    }
    
    func eraseDBFiles() {
        let version = CoreDataStack.Version(dbVersion)
        if let url = version.dbFileURL(testDirectory, .userDomainMask) {
            try? FileManager().removeItem(at: url)
        }
    }
}

// MARK: - Schema Version 1

final class CoreDataStackV1Tests: CoreDataStackTests {
    
    override var dbVersion: UInt { 1 }

    func testInitialization() {
        let exp = XCTestExpectation(description: #function)
        
        let request = Pokemon.newFetchRequest()
        request.predicate = NSPredicate(value: true)
        request.fetchLimit = 1
        
        sut.fetchOne(request)
            .sink { error in
                exp.fulfill()
            } receiveValue: { model in
                XCTFail("No Model Should be Found")
            }
            .store(in: cancelBag)
        
        wait(for: [exp], timeout: 1)
    }
    
    func testInaccessibleDirectory() {
        let sut = CoreDataStack(directory: .adminApplicationDirectory,
                                domainMask: .systemDomainMask, version: dbVersion)
        let exp = XCTestExpectation(description: #function)
        let request = Pokemon.newFetchRequest()
        request.predicate = NSPredicate(value: true)
        request.fetchLimit = 1
        
        sut.fetchOne(request)
            .sink { error in
                exp.fulfill()
            } receiveValue: { model in
                XCTFail("No Model Should be Found")
            }
            .store(in: cancelBag)
        
        wait(for: [exp], timeout: 1)
    }
    
    func testCountingOnEmptyStore() {
        let request = Pokemon.newFetchRequest()
        request.predicate = NSPredicate(value: true)
        let exp = XCTestExpectation(description: #function)
        exp.expectedFulfillmentCount = 2
        sut.count(request)
            .sink { error in
                switch error {
                case .finished: exp.fulfill()
                case .failure(let error): XCTFail("Shoukd Not Throw Error\(error)")
                }
            } receiveValue: { count in
                XCTAssertEqual(count, 0)
                exp.fulfill()
            }
            .store(in: cancelBag)

        wait(for: [exp], timeout: 1)
    }
    
    func testStoringAndCountring() {
        let apiModel = PokemonAPISearchModel.mocks.first!
        
        let request = Pokemon.newFetchRequest()
        request.predicate = NSPredicate(value: true)
        
        let exp = XCTestExpectation(description: #function)
        
        sut.insert(Pokemon.self) { object in
            object.imageData = Data()
            object.apiId = apiModel.id
            object.baseExperience = apiModel.baseExperience
            object.height = apiModel.height
            object.name = apiModel.name
            object.order = apiModel.order
            object.frontDefault = apiModel.sprites.frontDefault
            object.types = apiModel.types.map(\.type.name).joined(separator: ",")
            object.weight = apiModel.weight
        }.flatMap { pokemon in
            self.sut.count(request)
        }
        .sink { error in
            switch error {
            case .finished: exp.fulfill()
            case .failure(let error): XCTFail("Shoukd Not Throw Error\(error)")
            }
        } receiveValue: { count in
            XCTAssertEqual(count, 1)
            exp.fulfill()
        }
        .store(in: cancelBag)
        
        wait(for: [exp], timeout: 1)
    }
    
    func testStoringAndFetch() {
        let apiModel = PokemonAPISearchModel.mocks.first!
        
        let request = Pokemon.newFetchRequest()
        request.predicate = NSPredicate(value: true)
        request.fetchLimit = 1
        
        let exp = XCTestExpectation(description: #function)
        
        sut.insert(Pokemon.self) { object in
            object.imageData = Data()
            object.apiId = apiModel.id
            object.baseExperience = apiModel.baseExperience
            object.height = apiModel.height
            object.name = apiModel.name
            object.order = apiModel.order
            object.frontDefault = apiModel.sprites.frontDefault
            object.types = apiModel.types.map(\.type.name).joined(separator: ",")
            object.weight = apiModel.weight
        }.flatMap { pokemon in
            self.sut.fetchOne(request)
        }
        .sink { error in
            switch error {
            case .finished: exp.fulfill()
            case .failure(let error): XCTFail("Shoukd Not Throw Error\(error)")
            }
        } receiveValue: { pokemonModel in
            XCTAssertEqual(pokemonModel.imageData, Data())
            XCTAssertEqual(pokemonModel.apiId,apiModel.id)
            XCTAssertEqual(pokemonModel.baseExperience,apiModel.baseExperience)
            XCTAssertEqual(pokemonModel.height,apiModel.height)
            XCTAssertEqual(pokemonModel.name,apiModel.name)
            XCTAssertEqual(pokemonModel.order,apiModel.order)
            XCTAssertEqual(pokemonModel.frontDefault,apiModel.sprites.frontDefault)
            XCTAssertEqual(pokemonModel.types,apiModel.types.map(\.type.name).joined(separator: ","))
            XCTAssertEqual(pokemonModel.weight,apiModel.weight)
            exp.fulfill()
        }
        .store(in: cancelBag)
        
        wait(for: [exp], timeout: 1)
    }
    
    func testPublisherAndInsert() {
        let apiModel = PokemonAPISearchModel.mocks.first!
        
        let request = Pokemon.newFetchRequest()
        request.predicate = NSPredicate(value: true)
        request.sortDescriptors = [.init(keyPath: \Pokemon.order, ascending: true)]
        
        let exp = XCTestExpectation(description: #function)
        exp.expectedFulfillmentCount = 1
        
        sut.insert(Pokemon.self) { object in
            object.imageData = Data()
            object.apiId = apiModel.id
            object.baseExperience = apiModel.baseExperience
            object.height = apiModel.height
            object.name = apiModel.name
            object.order = apiModel.order
            object.frontDefault = apiModel.sprites.frontDefault
            object.types = apiModel.types.map(\.type.name).joined(separator: ",")
            object.weight = apiModel.weight
        }
        .flatMap { ooo in
            self.sut.objectPublisher(fetchRequest: request)
                .replaceError(with: [])
        }
        .sink { _ in } receiveValue: { pokemones in
            XCTAssertEqual(pokemones.count, 1)
            XCTAssertNotNil(pokemones.first)

            let pokemonModel = pokemones.first!
            XCTAssertEqual(pokemonModel.imageData, Data())
            XCTAssertEqual(pokemonModel.apiId,apiModel.id)
            XCTAssertEqual(pokemonModel.baseExperience,apiModel.baseExperience)
            XCTAssertEqual(pokemonModel.height,apiModel.height)
            XCTAssertEqual(pokemonModel.name,apiModel.name)
            XCTAssertEqual(pokemonModel.order,apiModel.order)
            XCTAssertEqual(pokemonModel.frontDefault,apiModel.sprites.frontDefault)
            XCTAssertEqual(pokemonModel.types,apiModel.types.map(\.type.name).joined(separator: ","))
            XCTAssertEqual(pokemonModel.weight,apiModel.weight)
            exp.fulfill()
        }
        .store(in: cancelBag)
        
        wait(for: [exp], timeout: 4)
    }
}
