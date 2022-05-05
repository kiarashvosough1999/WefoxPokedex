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
        var pokemonesBagListService: PokemoneBagListService
        
        init(pokemonSerachServices: PokemonSerachServices,
             pokemonesBagListService: PokemoneBagListService) {
            self.pokemonSerachServices = pokemonSerachServices
            self.pokemonesBagListService = pokemonesBagListService
        }
        
        static var stub: Self {
            Services(pokemonSerachServices: PokemonSerachServicesSTUB(),
                     pokemonesBagListService: PokemoneBagListServiceSTUB())
        }
    }
}
