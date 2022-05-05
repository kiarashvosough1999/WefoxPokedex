//
//  PokemonSearchPersistentRepository.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import Combine
import CoreData

protocol PokemonSearchPersistentRepository: Repository {
    func pokemonExist(with id: Int32) -> AnyPublisher<Bool, Error>
    func savePokemon(model: PokemonSearchModel, imageData: Data) -> AnyPublisher<Bool, Error>
}

struct PokemonSearchPersistentRepositoryImpl: PokemonSearchPersistentRepository {
    
    let persistentStore: CoreDataPersistentStore
    
    init(persistentStore: CoreDataPersistentStore) {
        self.persistentStore = persistentStore
    }
    
    func pokemonExist(with id: Int32) -> AnyPublisher<Bool, Error> {
        let request = Pokemon.newFetchRequest()
        request.predicate = NSPredicate(format: "%K == %d", #keyPath(Pokemon.apiId) , id)
        return persistentStore
            .count(request)
            .map { count in
                count > 0
            }
            .mapError(mapPersistentDoimanErrors)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func savePokemon(model: PokemonSearchModel, imageData: Data) -> AnyPublisher<Bool, Error> {
        persistentStore.insert(Pokemon.self) { [model, imageData] object in
            object.from(from: model, imageData: imageData)
        }
        .map { [model, imageData] createdObject in
            createdObject.match(with: model, imageData: imageData)
        }
        .mapError(mapPersistentDoimanErrors(error:))
        .mapError { $0 as Error }
        .eraseToAnyPublisher()
    }
}

fileprivate extension Pokemon {
    func from(from apiModel: PokemonSearchModel, imageData: Data) {
        self.imageData = imageData
        self.apiId = apiModel.id
        self.baseExperience = apiModel.baseExperience
        self.height = apiModel.height
        self.name = apiModel.name
        self.order = apiModel.order
        self.frontDefault = apiModel.frontDefault
        self.types = apiModel.types.joined(separator: ",")
        self.weight = apiModel.weight
    }
    
    func match(with apiModel: PokemonSearchModel, imageData: Data) -> Bool {
        self.apiId == apiModel.id &&
        self.baseExperience == apiModel.baseExperience &&
        self.height == apiModel.height &&
        self.name == apiModel.name &&
        self.order == apiModel.order &&
        self.frontDefault == apiModel.frontDefault &&
        self.types == apiModel.types.joined(separator: ",") &&
        self.weight == apiModel.weight &&
        self.imageData == imageData
    }
}
