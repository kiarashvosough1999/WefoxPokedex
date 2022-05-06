//
//  PokemonImageRepository.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import Foundation
import Combine

protocol PokemonImageRepository: NetworkRepository {
    func getPokemonImageData(imageName: String) -> AnyPublisher<Data, Error>
}

struct PokemonImageRepositoryImpl: PokemonImageRepository {
    
    var session: URLSession
    
    var baseURL: String
    
    var bgQueue: DispatchQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func getPokemonImageData(imageName: String) -> AnyPublisher<Data, Error> {
        requestDownloadImage(endpoint: API.image(imageName: imageName))
    }
}

extension PokemonImageRepositoryImpl {
    enum API {
        case image(imageName: String)
    }
}

extension PokemonImageRepositoryImpl.API: NetworkAPIRequest {
    
    var version: NetworkAPIVersion {
        return .noVersion
    }
    
    var path: String {
        switch self {
        case let .image(imageName): return "/" + imageName
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .image: return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .image: return nil
        }
    }
    
    func body() throws -> Data? {
        .none
    }
}
