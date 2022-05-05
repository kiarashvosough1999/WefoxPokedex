//
//  DIContainer++NetworkRepositories.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

extension DIContainer {
    struct WebRepositories {
        let pokemonSearchRepository: PokemonSearchRepository
        let pokemonImageRepository: PokemonImageRepository
        
        init(pokemonSearchRepository: PokemonSearchRepository, pokemonImageRepository: PokemonImageRepository) {
            self.pokemonSearchRepository = pokemonSearchRepository
            self.pokemonImageRepository = pokemonImageRepository
        }
    }
}

