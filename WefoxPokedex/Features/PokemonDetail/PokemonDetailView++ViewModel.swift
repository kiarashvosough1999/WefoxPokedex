//
//  PokemonDetailView++ViewModel.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/5/22.
//

import Foundation
import Combine

extension PokemonDetailView {

    final class ViewModel: ObservableObject {
        
        @Published var pokemoneDetail: Loadable<PokemoneDetailModel>
        private let pokemoneId: Int32
        let container: DIContainer
        private var cancelables = Cancelables()
        
        init(container: DIContainer, pokemoneId: Int32, pokemoneDetail: Loadable<PokemoneDetailModel> = .notRequested) {
            self.container = container
            self.pokemoneDetail = pokemoneDetail
            self.pokemoneId = pokemoneId
        }

        func loadPokemoneDetail() {
            pokemoneDetail.setIsLoading(cancelBag: cancelables)
            container
                .services
                .pokemoneDetailService
                .getPokemone(with: self.pokemoneId)
                .sinkToLoadable { self.pokemoneDetail = $0 }
                .store(in: cancelables)
        }
    }
}
