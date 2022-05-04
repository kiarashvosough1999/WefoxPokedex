//
//  NetworkRepository.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import Foundation
import Combine

protocol NetworkRepository {
    var session: URLSession { get }
    var baseURL: String { get }
    var bgQueue: DispatchQueue { get }
}

extension NetworkRepository {
    func request<Value>(endpoint: NetworkAPIRequest, httpCodes: HTTPStatusCodes = .success) -> AnyPublisher<Value, Error>
        where Value: Decodable {
        do {
            let request = try endpoint.urlRequest(baseURL: baseURL)
            return session
                .dataTaskPublisher(for: request)
                .requestJSON(httpCodes: httpCodes)
        } catch let error {
            return Fail<Value, Error>(error: error).eraseToAnyPublisher()
        }
    }
    
    func requestDownloadImage(endpoint: NetworkAPIRequest, httpCodes: HTTPStatusCodes = .success)  -> AnyPublisher<Data, Error> {
        do {
            let request = try endpoint.urlRequest(baseURL: baseURL)
            return session
                .dataTaskPublisher(for: request)
                .downloadImage(httpCodes: httpCodes)
        } catch let error {
            return Fail<Data, Error>(error: error).eraseToAnyPublisher()
        }
    }
}

// MARK: - Helpers

private extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func requestJSON<Value>(httpCodes: HTTPStatusCodes) -> AnyPublisher<Value, Error> where Value: Decodable {
        return tryMap {
                assert(!Thread.isMainThread)
                guard let code = ($0.1 as? HTTPURLResponse)?.statusCode else {
                    throw APIError.unexpectedResponse
                }
                guard httpCodes.contains(code) else {
                    throw APIError.httpCode(code)
                }
                return $0.0
            }
            .extractUnderlyingError()
            .decode(type: Value.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func downloadImage(httpCodes: HTTPStatusCodes) -> AnyPublisher<Data, Error> {
        tryMap { (data, response) in
            assert(!Thread.isMainThread)
            let httpResponse = response as? HTTPURLResponse
            
            guard let code = httpResponse?.statusCode else {
                throw APIError.unexpectedResponse
            }
            guard httpCodes.contains(code) else {
                throw APIError.httpCode(code)
            }
            guard let mimeType = httpResponse?.mimeType, mimeType.hasPrefix("image") else {
                throw APIError.imageDownloadingError
            }
            return data
        }
        .extractUnderlyingError()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
