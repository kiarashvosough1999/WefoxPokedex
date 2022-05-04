//
//  PokemonSearchRepository.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import Combine
import Foundation

protocol PokemonSearchRepository: NetworkRepository {
    func getRandomPokemon(randomNumber: Int) -> AnyPublisher<[PokemonAPISearchModel], Error>
}

struct PokemonSearchRepositoryImpl: PokemonSearchRepository {
    
    var session: URLSession
    
    var baseURL: String
    
    var bgQueue: DispatchQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func getRandomPokemon(randomNumber: Int) -> AnyPublisher<[PokemonAPISearchModel], Error> {
        request(endpoint: API.random(number: randomNumber))
    }
}

extension PokemonSearchRepositoryImpl {
    fileprivate enum API {
        case random(number: Int)
    }
}

extension PokemonSearchRepositoryImpl.API: NetworkAPIRequest {
    
    var version: NetworkAPIVersion {
        switch self {
        case .random: return .v2
        }
    }
    
    var path: String {
        switch self {
        case let .random(number): return "/\(number)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .random: return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .random: return ["Accept": "application/json"]
        }
    }
    
    func body() throws -> Data? {
        .none
    }
}
