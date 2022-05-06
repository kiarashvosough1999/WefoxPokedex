//
//  LoadingViewTests.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

@testable import WefoxPokedex
import XCTest
import ViewInspector

extension ActivityIndicatorView: Inspectable {}

final class LoadingViewTests: XCTestCase {
    
    func testActivityIndicator() throws {
        let view = LoadingView {
            
        }
        let exp = view.inspection.inspect { view in
            XCTAssertNoThrow(try view.find(ActivityIndicatorView.self))
            XCTAssertNoThrow(try view.find(ViewType.Button.self).find(text: "Cancel loading"))
        }
        ViewHosting.host(view: view)
        wait(for: [exp], timeout: 2)
    }
    
}
