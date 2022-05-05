//
//  PokemonBagListView++ViewModel.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/5/22.
//

import Foundation
import Combine

// MARK: - Routing

extension PokemonBagListView {
    struct Routing: Equatable {
        var pokemoneTakeSheet: Bool = false
        var pokemonDetailPage: Int32?
    }
}

// MARK: - ViewModel

extension PokemonBagListView {

    final class ViewModel: ObservableObject {

        @Published var routingState: Routing
        @Published var pokemones: Loadable<[PokemonBagListModel]>
        
        let container: DIContainer
        private var cancelables = Cancelables()

        init(container: DIContainer) {
            self.container = container
            self.pokemones = .notRequested
            let appState = container.appState
            _routingState = .init(initialValue: appState.value.routing.pokemonesBagList)
            cancelables.collect {
                $routingState
                    .sink { appState[\.routing.pokemonesBagList] = $0 }
                appState.map(\.routing.pokemonesBagList)
                    .removeDuplicates()
                    .weakAssign(to: \.routingState, on: self)
            }
        }

        // MARK: - Side Effects

        func startObservingCatchedPokemons() {
            self.pokemones.setIsLoading(cancelBag: cancelables)
            container
                .services
                .pokemonesBagListService
                .observePokemonesBag()
                .sinkToLoadable { self.pokemones = $0 }
                .store(in: cancelables)
        }

        func showPokemoneSearch() {
            routingState.pokemoneTakeSheet = true
        }
    }
}
