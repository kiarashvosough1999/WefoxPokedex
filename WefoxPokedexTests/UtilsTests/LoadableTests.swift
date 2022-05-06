//
//  LoadableTests.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/5/22.
//

import XCTest
import Combine
@testable import WefoxPokedex

final class LoadableTests: XCTestCase {

    func testEquality() {
        let possibleValues: [Loadable<Int>] = [
            .notRequested,
            .isLoading(last: nil, cancelBag: Cancelables()),
            .isLoading(last: 9, cancelBag: Cancelables()),
            .loaded(5),
            .loaded(6),
            .failed(NSError.test)
        ]
        possibleValues.enumerated().forEach { (index1, value1) in
            possibleValues.enumerated().forEach { (index2, value2) in
                if index1 == index2 {
                    XCTAssertEqual(value1, value2)
                } else {
                    XCTAssertNotEqual(value1, value2)
                }
            }
        }
    }
    
    func testCancelLoading() {
        let cancenBag1 = Cancelables(), cancenBag2 = Cancelables()
        let subject = PassthroughSubject<Int, Never>()
        subject.sink { _ in }
            .store(in: cancenBag1)
        subject.sink { _ in }
            .store(in: cancenBag2)
        var sut1 = Loadable<Int>.isLoading(last: nil, cancelBag: cancenBag1)
        XCTAssertEqual(cancenBag1.subscriptions.count, 1)
        sut1.cancelLoading()
        XCTAssertEqual(cancenBag1.subscriptions.count, 0)
        XCTAssertNotNil(sut1.error)
        var sut2 = Loadable<Int>.isLoading(last: 7, cancelBag: cancenBag2)
        XCTAssertEqual(cancenBag2.subscriptions.count, 1)
        sut2.cancelLoading()
        XCTAssertEqual(cancenBag2.subscriptions.count, 0)
        XCTAssertEqual(sut2.value, 7)
    }

    func testHelperFunctions() {
        let notRequested = Loadable<Int>.notRequested
        let loadingNil = Loadable<Int>.isLoading(last: nil, cancelBag: Cancelables())
        let loadingValue = Loadable<Int>.isLoading(last: 9, cancelBag: Cancelables())
        let loaded = Loadable<Int>.loaded(5)
        let failedErrValue = Loadable<Int>.failed(NSError.test)
        [notRequested, loadingNil].forEach {
            XCTAssertNil($0.value)
        }
        [loadingValue, loaded].forEach {
            XCTAssertNotNil($0.value)
        }
        [notRequested, loadingNil, loadingValue, loaded].forEach {
            XCTAssertNil($0.error)
        }
        XCTAssertNotNil(failedErrValue.error)
    }
}
