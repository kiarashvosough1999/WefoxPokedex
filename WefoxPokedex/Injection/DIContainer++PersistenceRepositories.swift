//
//  DIContainer++PersistenceRepositories.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

extension DIContainer {
    struct DBRepositories {
        let pokemonSearchPersistentRepository: PokemonSearchPersistentRepository
        
        init(pokemonSearchPersistentRepository: PokemonSearchPersistentRepository) {
            self.pokemonSearchPersistentRepository = pokemonSearchPersistentRepository
        }
    }
}
