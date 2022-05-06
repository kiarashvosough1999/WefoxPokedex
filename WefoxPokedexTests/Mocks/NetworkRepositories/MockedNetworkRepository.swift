//
//  MockedNetworkRepositories.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/5/22.
//

import Foundation
@testable import WefoxPokedex

class MockedNetworkRepository: NetworkRepository {
    let session: URLSession = .mockedResponsesOnly
    let baseURL = "https://test.com"
    let bgQueue = DispatchQueue(label: "test")
}
