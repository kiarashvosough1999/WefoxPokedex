//
//  DIContainer++Services.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import Foundation

extension DIContainer {
    struct Services {
        
        let pokemonSerachServices: PokemonSerachServices
        let pokemonesBagListService: PokemoneBagListService
        let pokemoneDetailService: PokemoneDetailService
        
        init(pokemonSerachServices: PokemonSerachServices,
             pokemonesBagListService: PokemoneBagListService,
             pokemoneDetailService: PokemoneDetailService) {
            self.pokemonSerachServices = pokemonSerachServices
            self.pokemonesBagListService = pokemonesBagListService
            self.pokemoneDetailService = pokemoneDetailService
        }
        
        static var stub: Self {
            Services(pokemonSerachServices: PokemonSerachServicesSTUB(),
                     pokemonesBagListService: PokemoneBagListServiceSTUB(),
                     pokemoneDetailService: PokemoneDetailServiceSTUB())
        }
    }
}
