//
//  PokemonSearchPersistentRepository.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import Combine
import CoreData

protocol PokemonSearchPersistentRepository: Repository {
    func pokemonExist(with id: Int32) -> AnyPublisher<Bool, ServiceError>
}

struct PokemonSearchPersistentRepositoryImpl: PokemonSearchPersistentRepository {
    
    let persistentStore: CoreDataPersistentStore
    
    func pokemonExist(with id: Int32) -> AnyPublisher<Bool, ServiceError> {
        let request = Pokemon.newFetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Pokemon.apiId) , id)
        return persistentStore
            .count(request)
            .map { $0 > 0 }
            .mapError(mapPersistentDoimanErrors)
            .eraseToAnyPublisher()
    }
}
