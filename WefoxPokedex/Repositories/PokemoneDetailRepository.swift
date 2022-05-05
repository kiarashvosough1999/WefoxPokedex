//
//  PokemoneDetailRepository.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/5/22.
//

import Foundation
import Combine

protocol PokemoneDetailRepository: Repository {
    func getPokemone(with id: Int32) -> AnyPublisher<PokemoneDetailModel,Error>
}

struct PokemoneDetailRepositoryImpl: PokemoneDetailRepository {
    
    private let persistentStore: CoreDataPersistentStore
    
    init(persistentStore: CoreDataPersistentStore) {
        self.persistentStore = persistentStore
    }
    
    func getPokemone(with id: Int32) -> AnyPublisher<PokemoneDetailModel,Error> {
        let fetchRequest = Pokemon.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "%K == %d", #keyPath(Pokemon.apiId) , id)
        
        return persistentStore
            .fetchOne(fetchRequest)
            .map(PokemoneDetailModel.init(from:))
            .mapError(mapPersistentDoimanErrors(error:))
            .eraseToAnyPublisher()
    }
}

fileprivate extension PokemoneDetailModel {
    init(from persistenceObject: Pokemon) {
        self.baseExperience = persistenceObject.baseExperience
        self.height = persistenceObject.height
        self.id = persistenceObject.apiId
        self.name = persistenceObject.name.or("")
        self.order = persistenceObject.order
        self.imageData = persistenceObject.imageData.or(Data())
        self.types = persistenceObject.types.or("")
        self.weight = persistenceObject.weight
    }
}
