//
//  DIContainer++NetworkRepositories.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

extension DIContainer {
    struct WebRepositories {
        let pokemonSearchRepository: PokemonSearchRepository
        
        init(pokemonSearchRepository: PokemonSearchRepository) {
            self.pokemonSearchRepository = pokemonSearchRepository
        }
    }
}

