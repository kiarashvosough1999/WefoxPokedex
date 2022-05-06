//
//  RequestBlocking++URLProtocol.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

import Foundation

// MARK: - RequestBlocking

final class RequestBlocking: URLProtocol {
    
    enum Error: Swift.Error {
        case requestBlocked
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        DispatchQueue(label: "").async {
            self.client?.urlProtocol(self, didFailWithError: Error.requestBlocked)
        }
    }
    override func stopLoading() { }
}
