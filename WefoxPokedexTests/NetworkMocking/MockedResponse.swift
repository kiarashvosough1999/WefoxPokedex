//
//  MockedResponse.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/5/22.
//

import Foundation
@testable import WefoxPokedex

extension RequestMocking {
    
    struct MockedResponse {
        
        let url: URL
        let result: Result<Data, Swift.Error>
        let httpCode: HTTPStatusCode
        let headers: [String: String]
        let loadingTime: TimeInterval
        let customResponse: URLResponse?
        
        enum Error: Swift.Error {
            case failedMockCreation
        }
        
        init<T>(apiCall: NetworkAPIRequest, baseURL: String,
                result: Result<T, Swift.Error>,
                httpCode: HTTPStatusCode = 200,
                headers: [String: String] = ["Content-Type": "application/json"],
                loadingTime: TimeInterval = 0.1) throws where T: Encodable {
            guard let url = try apiCall.urlRequest(baseURL: baseURL).url else { throw Error.failedMockCreation }
            self.url = url
            switch result {
            case let .success(value):
                self.result = .success(try JSONEncoder().encode(value))
            case let .failure(error):
                self.result = .failure(error)
            }
            self.httpCode = httpCode
            self.headers = headers
            self.loadingTime = loadingTime
            customResponse = nil
        }
        
        init<T>(apiCall: NetworkAPIRequest, baseURL: String,
                result: Result<T, Swift.Error>,
                httpCode: HTTPStatusCode = 200,
                customResponse: URLResponse,
                headers: [String: String] = ["Content-Type": "application/json"],
                loadingTime: TimeInterval = 0.1) throws where T: Encodable {
            guard let url = try apiCall.urlRequest(baseURL: baseURL).url else { throw Error.failedMockCreation }
            self.url = url
            switch result {
            case let .success(value):
                self.result = .success(try JSONEncoder().encode(value))
            case let .failure(error):
                self.result = .failure(error)
            }
            self.httpCode = httpCode
            self.headers = headers
            self.loadingTime = loadingTime
            self.customResponse = customResponse
        }
        
        init(apiCall: NetworkAPIRequest, baseURL: String, customResponse: URLResponse) throws {
            guard let url = try apiCall.urlRequest(baseURL: baseURL).url
            else { throw Error.failedMockCreation }
            self.url = url
            result = .success(Data())
            httpCode = 200
            headers = [String: String]()
            loadingTime = 0
            self.customResponse = customResponse
        }
        
        init(apiCall: NetworkAPIRequest, baseURL: String, resultData: Data, mimeType: String, expectedContentLength: Int) throws {
            guard let url = try apiCall.urlRequest(baseURL: baseURL).url
            else { throw Error.failedMockCreation }
            self.url = url
            self.result = .success(resultData)
            httpCode = 200
            headers = [String: String]()
            loadingTime = 0
            self.customResponse = HTTPURLResponse(url: url, mimeType: mimeType, expectedContentLength: expectedContentLength, textEncodingName: nil)
        }
        
        init(url: URL, result: Result<Data, Swift.Error>) {
            self.url = url
            self.result = result
            httpCode = 200
            headers = [String: String]()
            loadingTime = 0
            customResponse = nil
        }
    }
}
