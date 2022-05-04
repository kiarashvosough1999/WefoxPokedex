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
    func savePokemon(model: PokemonSearchModel) -> AnyPublisher<Bool, Error>
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
    
    func savePokemon(model: PokemonSearchModel) -> AnyPublisher<Bool, Error> {
        persistentStore.insert(Pokemon.self) { object in
            object.apiId = model.id
            object.baseExperience = model.baseExperience
            object.height = model.height
            object.name = model.name
            object.order = model.order
            object.frontDefault = model.frontDefault
            object.types = model.types.joined(separator: ",")
            object.weight = model.weight
        }
        .map { createdObject in
            createdObject.apiId == model.id &&
            createdObject.baseExperience == model.baseExperience &&
            createdObject.height == model.height &&
            createdObject.name == model.name &&
            createdObject.order == model.order &&
            createdObject.frontDefault == model.frontDefault &&
            createdObject.types == model.types.joined(separator: ",") &&
            createdObject.weight == model.weight
        }
        .mapError(mapPersistentDoimanErrors(error:))
        .mapError { $0 as Error }
        .eraseToAnyPublisher()
    }
}
