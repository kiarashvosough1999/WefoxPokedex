//
//  APIRequest.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import Foundation

protocol NetworkAPIRequest {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var version: NetworkAPIVersion { get }
    func body() throws -> Data?
}

extension NetworkAPIRequest {
    func urlRequest(baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + version.rawValue + path) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.name
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()
        return request
    }
}
