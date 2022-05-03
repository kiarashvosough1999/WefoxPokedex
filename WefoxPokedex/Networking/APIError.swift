//
//  APIError.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import Foundation

enum APIError: Swift.Error {
    case invalidURL
    case httpCode(HTTPStatusCode)
    case unexpectedResponse
    case imageProcessing([URLRequest])
}
