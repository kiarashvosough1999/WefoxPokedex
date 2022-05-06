//
//  SearchPokemonTests.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

@testable import WefoxPokedex
import XCTest
import ViewInspector

extension SearchPokemon: Inspectable {}
extension LoadingView: Inspectable {}
extension KeyValueTextRow: Inspectable {}
extension MeteredVStack: Inspectable {}

final class SearchPokemonTests: XCTestCase {
    
    private var mockedPokemonSerachServices: MockedPokemonSerachServices!
    private var container: DIContainer!
    
    func searchPokemonView(isDisplayed: Bool,
                           searchState: Loadable<PokemonSearchResult>) -> SearchPokemon {
        let services = DIContainer.Services(pokemonSerachServices: mockedPokemonSerachServices,
                                            pokemonesBagListService: PokemoneBagListServiceSTUB(),
                                            pokemoneDetailService: PokemoneDetailServiceSTUB())
        container = DIContainer(appState: AppState(), services: services)
        return SearchPokemon(viewModel: .init(container: container,
                                              isDisplayed: .constant(isDisplayed),
                                              searchState: searchState))
    }
    
    override func tearDown() {
        container = nil
    }
    
    func testSearchPokemoneNotRequested() {
        
        mockedPokemonSerachServices = .init(expected: [])
        
        let sut = searchPokemonView(isDisplayed: true, searchState: .notRequested)
        
        let exp = sut.inspection.inspect { view in
            XCTAssertNoThrow(try view.find(LoadingView.self))
            XCTAssertEqual(self.container.appState.value, AppState())
            self.mockedPokemonSerachServices.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func testSearchPokemoneLoaded() {
        
        let mockedModel = PokemonSearchModel.mocks.first!
        
        mockedPokemonSerachServices = .init(expected: [])
        mockedPokemonSerachServices.getRandomPokemonResponse = .success(.new(model: mockedModel))
        
        let sut = searchPokemonView(isDisplayed: true, searchState: .loaded(.new(model: mockedModel)))
        
        let exp = sut.inspection.inspect { view in
            XCTAssertNoThrow(
                try view
                    .find(ViewType.List.self)
                    .find(KeyValueTextRow.self)
                    .find(ViewType.HStack.self)
                    .find(text: mockedModel.name)
            )
            XCTAssertEqual(self.container.appState.value, AppState())
            self.mockedPokemonSerachServices.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
}
