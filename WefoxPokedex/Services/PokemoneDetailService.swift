//
//  PokemoneDetailService.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/5/22.
//

import Foundation
import Combine

protocol PokemoneDetailService {
    func getPokemone(with id: Int32) -> AnyPublisher<PokemoneDetailModel,Error>
}

struct PokemoneDetailServiceImpl: PokemoneDetailService {
    
    private let pokemoneDetailRepository: PokemoneDetailRepository
    private let appState: Store<AppState>
    
    init(pokemoneDetailRepository: PokemoneDetailRepository, appState: Store<AppState>) {
        self.pokemoneDetailRepository = pokemoneDetailRepository
        self.appState = appState
    }
    
    func getPokemone(with id: Int32) -> AnyPublisher<PokemoneDetailModel,Error> {
        pokemoneDetailRepository
            .getPokemone(with: id)
    }
}

struct PokemoneDetailServiceSTUB: PokemoneDetailService {
    func getPokemone(with id: Int32) -> AnyPublisher<PokemoneDetailModel,Error> {
        Empty<PokemoneDetailModel,Error>().eraseToAnyPublisher()
    }
}
