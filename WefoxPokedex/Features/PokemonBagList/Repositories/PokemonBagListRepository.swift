//
//  PokemonBagListRepository.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/5/22.
//

import Combine
import CoreData

protocol PokemonBagListRepository: Repository {
    func objectPublisherForPokemonBag<T>(sortedBy keyPath: KeyPath<Pokemon,T>, ascending: Bool) -> AnyPublisher<[PokemonBagListModel],Error>
}

struct PokemonBagListRepositoryImpl: PokemonBagListRepository {

    private let persistentStore: CoreDataPersistentStore

    init(persistentStore: CoreDataPersistentStore) {
        self.persistentStore = persistentStore
    }

    func objectPublisherForPokemonBag<T>(sortedBy keyPath: KeyPath<Pokemon,T>, ascending: Bool) -> AnyPublisher<[PokemonBagListModel],Error> {
        let fetchRequest = Pokemon.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: keyPath, ascending: ascending)
        ]
        return persistentStore
            .objectPublisher(fetchRequest: fetchRequest)
            .map { $0.map(PokemonBagListModel.init(from:)) }
            .eraseToAnyPublisher()
    }
}

// MARK: - PokemonBagListModel Init Mapper

fileprivate extension PokemonBagListModel {
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
