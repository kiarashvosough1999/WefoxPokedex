//
//  SearchPokemon++ViewModel.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import SwiftUI

// MARK: - ViewModel

extension SearchPokemon {
    class ViewModel: ObservableObject {
        
        // State
        @Binding private var isDisplayed: Bool
        @Published var searchState: Loadable<PokemonSearchResult>
        
        // Misc
        let container: DIContainer
        private var cancelables = Cancelables()
        
        init(container: DIContainer,
             isDisplayed: Binding<Bool>,
             searchState: Loadable<PokemonSearchResult> = .notRequested) {
            self.container = container
            self.searchState = searchState
            self._searchState = .init(initialValue: searchState)
            self._isDisplayed = isDisplayed
        }
        
        // MARK: - Side Effects
        
        func loadRandomPokemon() {
            searchState.setIsLoading(cancelBag: cancelables)
            container
                .services
                .pokemonSerachServices
                .getRandomPokemon()
                .sinkToLoadable { self.searchState = $0 }
                .store(in: cancelables)
        }
        
        func takePokemon() {
            guard let pokemonModel = self.searchState.value?.model else { return }
            searchState.setIsLoading(cancelBag: cancelables)
            container
                .services
                .pokemonSerachServices
                .savePokemon(model: pokemonModel)
                .replaceError(with: false)
                .map { succeed in
                    !succeed
                }
                .sink { searchSheetPresentState in
                    self.isDisplayed = searchSheetPresentState
                }
                .store(in: cancelables)
        }
        
        func dismiss() {
            self.isDisplayed = false
        }
    }
}
