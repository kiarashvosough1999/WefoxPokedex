//
//  DIContainer++Services.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import Foundation

extension DIContainer {
    struct Services {
        
        var pokemonSerachServices: PokemonSerachServices
        
        init(pokemonSerachServices: PokemonSerachServices) {
            self.pokemonSerachServices = pokemonSerachServices
        }
        
        static var stub: Self {
            Services(pokemonSerachServices: PokemonSerachServicesSTUB())
        }
    }
}
