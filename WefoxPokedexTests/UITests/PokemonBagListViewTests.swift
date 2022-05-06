//
//  PokemonBagListViewTests.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

@testable import WefoxPokedex
import XCTest
import ViewInspector

extension PokemonBagListView: Inspectable {}

class PokemonBagListViewTests: XCTestCase {
    
    private var mockedPokemoneBagListService: MockedPokemoneBagListService!
    private var container: DIContainer!
    
    
    func pokemonBagListView() -> PokemonBagListView {
        let services = DIContainer.Services(pokemonSerachServices: PokemonSerachServicesSTUB(),
                                            pokemonesBagListService: mockedPokemoneBagListService,
                                            pokemoneDetailService: PokemoneDetailServiceSTUB())
        container = DIContainer(appState: AppState(), services: services)
        return PokemonBagListView(viewModel:
                .init(container: container)
        )
    }
    
    override func tearDown() {
        container = nil
    }

    func testEmptyBag() throws {
        
        mockedPokemoneBagListService = .init(expected: [.observePokemonesBag])
        mockedPokemoneBagListService.observePokemonesBagResponse = .success([])
        let sut = pokemonBagListView()
        
        let exp = sut.inspection.inspect { view in
            XCTAssertNoThrow(
                try view.find(ViewType.List.self)
            )
            XCTAssertThrowsError(try view.find(PokemonDetailView.self))
            XCTAssertEqual(self.container.appState.value, AppState())
            self.mockedPokemoneBagListService.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func testNotEmptyBag() throws {
        
        let mockModels = PokemonBagListModel.mocks
        
        mockedPokemoneBagListService = .init(expected: [.observePokemonesBag])
        mockedPokemoneBagListService.observePokemonesBagResponse = .success(mockModels)
        let sut = pokemonBagListView()
        
        let exp = sut.inspection.inspect { view in
            XCTAssertNoThrow(
                try view.find(ViewType.List.self)
            )
            XCTAssertThrowsError(try view.find(PokemonDetailView.self).find(text: mockModels[0].name))
            XCTAssertThrowsError(try view.find(PokemonDetailView.self).find(text: mockModels[2].name))
            XCTAssertThrowsError(try view.find(PokemonDetailView.self).find(text: mockModels[3].name))
            XCTAssertEqual(self.container.appState.value, AppState())
            self.mockedPokemoneBagListService.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
}
