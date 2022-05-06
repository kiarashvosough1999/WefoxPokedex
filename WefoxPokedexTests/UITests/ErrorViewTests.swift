//
//  ErrorViewTests.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

@testable import WefoxPokedex
import XCTest
import ViewInspector

extension ErrorView: Inspectable {}

final class ErrorViewTests: XCTestCase {
    
    fileprivate enum UIError: String, Swift.Error {
        case blocked
    }
    
    func testErrorView() throws {
        let view = ErrorView(error: UIError.blocked) {}
        let exp = view.inspection.inspect { view in
            XCTAssertNoThrow(try view.find(ViewType.Text.self).find(text: "An Error Occured"))
            XCTAssertNoThrow(
                try view
                    .find(ViewType.Button.self)
                    .find(ViewType.Text.self)
                    .find(text: "Retry")
            )
            XCTAssertNoThrow(try view.find(ViewType.VStack.self).find(textWhere: { text, attributes in
                let font = try attributes.font()
                return font == .callout
            }))
        }
        ViewHosting.host(view: view)
        wait(for: [exp], timeout: 2)
    }
    
}
