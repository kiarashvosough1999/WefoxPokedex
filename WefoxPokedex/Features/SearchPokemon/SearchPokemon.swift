//
//  SearchPokemon.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import SwiftUI

struct SearchPokemon: View {
    
    @ObservedObject private(set) var viewModel: ViewModel
    let inspection = Inspection<Self>()
    
    var body: some View {
        content
            .ignoresSafeArea([.container], edges: .top)
            .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
    
    private var content: AnyView {
        switch viewModel.searchState {
        case .notRequested: return AnyView(notRequestedView)
        case .isLoading: return AnyView(loadingView)
        case .failed(let error): return AnyView(failedView(error))
        case .loaded(let searchResult):
            switch searchResult {
            case .new(let model): return AnyView(loadedView(model: model, isTakeButtonDisabled: false))
            case .alreadyPicked(let model): return AnyView(loadedView(model: model, isTakeButtonDisabled: true))
            }
        }
    }
    
    private var loadingView: some View {
        LoadingView {
            self.viewModel.searchState.cancelLoading()
        }
    }
    
    private var notRequestedView: some View {
        NotRequestedView()
            .onAppear {
                viewModel.loadRandomPokemon()
            }
    }
    
    private func failedView(_ error: Error) -> some View {
        ErrorView(error: error) {
            self.viewModel.loadRandomPokemon()
        }
    }
    
    private func loadedView(model: PokemonSearchModel, isTakeButtonDisabled: Bool) -> some View {
        MeteredVStack { proxy in
            PokemonImage(imageURL: model.imageURL, proxyHeight: proxy.size.height)
            List {
                KeyValueTextRow(keyText: "Name", valueText: model.name)
                KeyValueTextRow(keyText: "Weight", valueText: model.weight.formatted())
                KeyValueTextRow(keyText: "Height", valueText: model.height.formatted())
            }
            HStack(alignment: .bottom, spacing: 10) {
                Spacer()
                FancyButton(title: "Catch", isDisabled: isTakeButtonDisabled, action: viewModel.takePokemon)
                FancyButton(title: "Throw Away",action: viewModel.dismiss)
                Spacer()
            }
        }
    }
}

#if DEBUG
struct SearchPokemon_Previews: PreviewProvider {
    static var previews: some View {
        SearchPokemon(viewModel: SearchPokemon.ViewModel(container: .preview, isDisplayed: .constant(true)))
    }
}
#endif
