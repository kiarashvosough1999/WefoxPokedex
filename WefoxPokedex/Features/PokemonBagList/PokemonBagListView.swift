//
//  PokemonBagListView.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/5/22.
//

import SwiftUI

struct PokemonBagListView: View {
    
    @ObservedObject private(set) var viewModel: ViewModel
    let inspection = Inspection<Self>()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        viewModel.startObservingCatchedPokemons()
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.pokemones.value ?? []) { item in
                NavigationLink(tag: item.id, selection: $viewModel.routingState.pokemonDetailPage) {
                    PokemonDetailView(viewModel: PokemonDetailView
                        .ViewModel(container: viewModel.container, pokemoneId: item.id)
                    )
                } label: {
                    PoekemonesItemView(imageData: item.imageData, name: item.name)
                }
            }
            .navigationBarHidden(false)
            .navigationTitle("Pokemones Bag")
            .navigationBarTitleDisplayMode(.large)
            .floatingButton(color: .indigo, image: Image(systemName: "plus")) {
                viewModel.showPokemoneSearch()
            }
            .sheet(isPresented: self.$viewModel.routingState.pokemoneTakeSheet) {
                searchPokemoneView()
            }
        }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
    
    private func searchPokemoneView() -> some View {
        SearchPokemon(viewModel: SearchPokemon
            .ViewModel(container: viewModel.container,
                       isDisplayed: $viewModel.routingState.pokemoneTakeSheet))
    }
}

#if DEBUG
struct PokemonBagListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonBagListView(viewModel: .init(container: .preview))
    }
}
#endif
