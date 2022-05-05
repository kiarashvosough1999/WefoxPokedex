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
        let pokemoneDetailRepository: PokemoneDetailRepository
        
        init(pokemonSearchPersistentRepository: PokemonSearchPersistentRepository,
             pokemonBagListRepository: PokemonBagListRepository,
             pokemoneDetailRepository: PokemoneDetailRepository) {
            self.pokemonSearchPersistentRepository = pokemonSearchPersistentRepository
            self.pokemonBagListRepository = pokemonBagListRepository
            self.pokemoneDetailRepository = pokemoneDetailRepository
        }
    }
}
