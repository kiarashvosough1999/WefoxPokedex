//
//  PokemoneBagListService.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/5/22.
//

import Foundation
import Combine

protocol PokemoneBagListService {
    func observePokemonesBag() -> AnyPublisher<[PokemonBagListModel],Error>
}

struct PokemoneBagListServiceImpl: PokemoneBagListService {

    private let pokemonBagListRepository: PokemonBagListRepository
    private let appState: Store<AppState>
    
    init(pokemonBagListRepository: PokemonBagListRepository, appState: Store<AppState>) {
        self.pokemonBagListRepository = pokemonBagListRepository
        self.appState = appState
    }

    func observePokemonesBag() -> AnyPublisher<[PokemonBagListModel],Error> {
        pokemonBagListRepository
            .objectPublisherForPokemonBag(sortedBy: "order", ascending: true)
            .eraseToAnyPublisher()
    }
}

struct PokemoneBagListServiceSTUB: PokemoneBagListService {
    func observePokemonesBag() -> AnyPublisher<[PokemonBagListModel],Error> {
        Empty<[PokemonBagListModel],Error>().eraseToAnyPublisher()
    }
}
