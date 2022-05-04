//
//  PokemonSerachServices.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import Combine
import Foundation

protocol PokemonSerachServices {
    func getRandomPokemon() -> AnyPublisher<PokemonSearchResult,Error>
    func savePokemon(model: PokemonSearchModel) -> AnyPublisher<Bool,Error>
}

struct PokemonSerachServicesImpl: PokemonSerachServices {
    
    private let pokemonSearchRepository: PokemonSearchRepository
    private let pokemonSearchPersistentRepository: PokemonSearchPersistentRepository
    private let pokemonImageRepository: PokemonImageRepository
    private let appState: Store<AppState>
    
    var randomPokemonNumber: Int {
        .random(in: 1...1000)
    }
    
    init(pokemonSearchRepository: PokemonSearchRepository,
         pokemonSearchPersistentRepository: PokemonSearchPersistentRepository,
         pokemonImageRepository: PokemonImageRepository,
         appState: Store<AppState>) {
        self.pokemonSearchRepository = pokemonSearchRepository
        self.pokemonSearchPersistentRepository = pokemonSearchPersistentRepository
        self.pokemonImageRepository = pokemonImageRepository
        self.appState = appState
    }
    
    func getRandomPokemon() -> AnyPublisher<PokemonSearchResult,Error> {
        return pokemonSearchRepository
            .getRandomPokemon(randomNumber: randomPokemonNumber)
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
    
    func savePokemon(model: PokemonSearchModel) -> AnyPublisher<Bool,Error> {
        if let imageName = URL(string: model.frontDefault)?.lastPathComponent {
            return pokemonImageRepository
                .getPokemonImageData(imageName: imageName)
                .replaceError(with: Data())
                .flatMap { imageData in
                    self.pokemonSearchPersistentRepository
                        .savePokemon(model: model, imageData: imageData)
                }
                .eraseToAnyPublisher()
        } else {
            return pokemonSearchPersistentRepository
                .savePokemon(model: model, imageData: Data())
                .eraseToAnyPublisher()
        }
    }
}

struct PokemonSerachServicesSTUB: PokemonSerachServices {
    
    func savePokemon(model: PokemonSearchModel) -> AnyPublisher<Bool, Error> {
        Empty<Bool,Error>().eraseToAnyPublisher()
    }

    func getRandomPokemon() -> AnyPublisher<PokemonSearchResult,Error> { Empty<PokemonSearchResult,Error>().eraseToAnyPublisher()
    }
}
