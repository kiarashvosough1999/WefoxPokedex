//
//  FancyButtonTests.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

@testable import WefoxPokedex
import XCTest
import ViewInspector

extension FancyButton: Inspectable {}

final class FancyButtonTests: XCTestCase {
    
    func testButtonEnabled() throws {
        let view = FancyButton(title: "Test1", isDisabled: false) {
            
        }
        let exp = view.inspection.inspect { view in
            XCTAssertNoThrow(
                try view
                    .find(ViewType.Button.self)
                    .find(ViewType.Text.self)
                    .find(text: "Test1")
            )
            XCTAssertNoThrow(
                try view.find(ViewType.Button.self)
                    .find(where: { attributes in
                        let opacity = try attributes.opacity()
                        return opacity == 1.0
                    })
            )
        }
        ViewHosting.host(view: view)
        wait(for: [exp], timeout: 2)
    }
    
    func testButtonDisabled() throws {
        let view = FancyButton(title: "Test1", isDisabled: true) {
            
        }
        let exp = view.inspection.inspect { view in
            XCTAssertNoThrow(
                try view
                    .find(ViewType.Button.self)
                    .find(ViewType.Text.self)
                    .find(text: "Test1")
            )
            
            XCTAssertNoThrow(
                try view.find(ViewType.Button.self)
                    .find(where: { attributes in
                        let opacity = try attributes.opacity()
                        return opacity == 0.5
                    })
            )
        }
        ViewHosting.host(view: view)
        wait(for: [exp], timeout: 2)
    }
}
