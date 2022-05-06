//
//  PokemonDetailViewTests.swift
//  WefoxPokedexTests
//
//  Created by Kiarash Vosough on 5/6/22.
//

import XCTest

@testable import WefoxPokedex
import XCTest
import ViewInspector

extension PokemonDetailView: Inspectable {}

class PokemonDetailViewTests: XCTestCase {
    
    private var mockedPokemoneDetailService: MockedPokemoneDetailService!
    private var container: DIContainer!
    
    
    func pokemonDetailView(pokemonId: Int32, pokemoneDetail: Loadable<PokemoneDetailModel> = .notRequested) -> PokemonDetailView {
        let services = DIContainer.Services(pokemonSerachServices: PokemonSerachServicesSTUB(),
                                            pokemonesBagListService: PokemoneBagListServiceSTUB(),
                                            pokemoneDetailService: mockedPokemoneDetailService)
        container = DIContainer(appState: AppState(), services: services)
        return PokemonDetailView(viewModel: .init(container: container,
                                                  pokemoneId: pokemonId,
                                                  pokemoneDetail: pokemoneDetail))
    }
    
    override func tearDown() {
        container = nil
    }

    func testEmptyBag() throws {
        
        let mockModel = PokemoneDetailModel.mocks.first!
        mockedPokemoneDetailService = .init(expected: [])
        mockedPokemoneDetailService.getPokemoneResponse = .success(mockModel)
        
        let sut = pokemonDetailView(pokemonId: mockModel.id, pokemoneDetail: .loaded(mockModel))
        
        let exp = sut.inspection.inspect { view in
            XCTAssertNoThrow(
                try view.find(text: mockModel.name)
            )
            XCTAssertNoThrow(
                try view.find(text: "\(mockModel.weight)")
            )
            XCTAssertNoThrow(
                try view.find(text: "\(mockModel.height)")
            )
            XCTAssertNoThrow(
                try view.find(text: "\(mockModel.baseExperience)")
            )
            XCTAssertNoThrow(
                try view.find(text: mockModel.types)
            )
            XCTAssertEqual(self.container.appState.value, AppState())
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
}
