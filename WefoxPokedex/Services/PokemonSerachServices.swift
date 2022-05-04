//
//  PokemonSerachServices.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import Combine

protocol PokemonSerachServices {
    func getRandomPokemon() -> AnyPublisher<PokemonSearchResult,Error>
}

struct PokemonSerachServicesImpl: PokemonSerachServices {
    
    private let pokemonSearchRepository: PokemonSearchRepository
    private let pokemonSearchPersistentRepository: PokemonSearchPersistentRepository
    private let appState: Store<AppState>
    
    var randomPokemonNumber: Int {
        .random(in: 1...1000)
    }
    
    init(pokemonSearchRepository: PokemonSearchRepository,
         pokemonSearchPersistentRepository: PokemonSearchPersistentRepository,
         appState: Store<AppState>) {
        self.pokemonSearchRepository = pokemonSearchRepository
        self.pokemonSearchPersistentRepository = pokemonSearchPersistentRepository
        self.appState = appState
    }
    
    func getRandomPokemon() -> AnyPublisher<PokemonSearchResult,Error> {
        return pokemonSearchRepository.getRandomPokemon(randomNumber: randomPokemonNumber)
            .flatMap { searchModel in
                self.pokemonSearchPersistentRepository.pokemonExist(with: searchModel.id)
                    .combineLatest(
                        Just(searchModel)
                            .setFailureType(to: Error.self)
                    ).eraseToAnyPublisher()
            }
            .map { (isPokemonAlreadySaved, searchModel) -> PokemonSearchResult in
                return isPokemonAlreadySaved ? .alreadyPicked(model: searchModel) : .new(model: searchModel)
            }
            .eraseToAnyPublisher()
    }
}

struct PokemonSerachServicesSTUB: PokemonSerachServices {
    
    func getRandomPokemon() -> AnyPublisher<PokemonSearchResult,Error> { Empty<PokemonSearchResult,Error>().eraseToAnyPublisher()
    }
}
