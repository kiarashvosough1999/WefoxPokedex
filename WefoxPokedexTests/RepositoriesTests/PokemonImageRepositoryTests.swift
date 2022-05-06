//
//  PokemonImageRepositoryTests.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

import Foundation
import XCTest
import Combine
@testable import WefoxPokedex

final class PokemonImageRepositoryTests: XCTestCase {

    private var sut: PokemonImageRepositoryImpl!
    private var subscriptions = Set<AnyCancellable>()
    
    typealias API = PokemonImageRepositoryImpl.API
    typealias Mock = RequestMocking.MockedResponse
    
    override func setUp() {
        subscriptions = Set<AnyCancellable>()
        sut = PokemonImageRepositoryImpl(session: .mockedResponsesOnly,
                                         baseURL: "https://test.com")
    }
    
    override func tearDown() {
        RequestMocking.removeAllMocks()
    }
    
    private func mock(_ apiCall: API,
                      expectedContentLength: Int,
                      resultData: Data,
                      httpCode: HTTPStatusCode = 200) throws {
        let mock = try Mock(apiCall: apiCall,
                            baseURL: sut.baseURL,
                            resultData: resultData,
                            mimeType: "image/png",
                            expectedContentLength: expectedContentLength)
        RequestMocking.add(mock: mock)
    }
    
    // MARK: - Tests
    
    func testRandomPokemon() throws {
        let testImage: TesableImage = TestImage1()
        
        let imageData = try XCTUnwrap(testImage.pngData)
        
        XCTAssertNotNil(imageData)
        
        try mock(.image(imageName: testImage.name), expectedContentLength: imageData.count, resultData: imageData)
        let exp = XCTestExpectation(description: "Completion")
        
        sut.getPokemonImageData(imageName: testImage.name)
            .sink { error in
                switch error {
                case .finished: break
                case .failure(let failure): XCTFail("Test failed in\(#file) at line \(#line) due to \(failure)")
                }
            } receiveValue: { data in
                XCTAssertEqual(data, imageData)
                exp.fulfill()
            }
            .store(in: &subscriptions)
        wait(for: [exp], timeout: 4)
    }
}
