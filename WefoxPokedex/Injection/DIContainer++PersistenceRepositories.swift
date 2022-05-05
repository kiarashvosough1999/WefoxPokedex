//
//  DIContainer++PersistenceRepositories.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

extension DIContainer {
    struct DBRepositories {
        let pokemonSearchPersistentRepository: PokemonSearchPersistentRepository
        let pokemonBagListRepository: PokemonBagListRepository
        
        init(pokemonSearchPersistentRepository: PokemonSearchPersistentRepository,
             pokemonBagListRepository: PokemonBagListRepository) {
            self.pokemonSearchPersistentRepository = pokemonSearchPersistentRepository
            self.pokemonBagListRepository = pokemonBagListRepository
        }
    }
}
