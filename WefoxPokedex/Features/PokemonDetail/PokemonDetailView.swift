//
//  PokemonDetailView.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/5/22.
//

import SwiftUI

struct PokemonDetailView: View {
    
    @ObservedObject private(set) var viewModel: ViewModel
    let inspection = Inspection<Self>()
    
    var body: some View {
        content
            .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
    
    private var content: AnyView {
        switch viewModel.pokemoneDetail {
            case .notRequested: return AnyView(notRequestedView)
            case .isLoading: return AnyView(loadingView)
            case .failed(let error): return AnyView(failedView(error))
            case .loaded(let model): return AnyView(loadedView(model: model))
        }
    }
    
    private var loadingView: some View {
        LoadingView {
            self.viewModel.pokemoneDetail.cancelLoading()
        }
    }
    
    private var notRequestedView: some View {
        NotRequestedView()
            .onAppear(perform: viewModel.loadPokemoneDetail)
    }
    
    private func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: viewModel.loadPokemoneDetail)
    }
    
    private func loadedView(model: PokemoneDetailModel) -> some View {
        MeteredVStack { proxy in
            Group {
                if let image = UIImage(data: model.imageData) {
                    Image(uiImage: image)
                        .resizable()
                } else {
                    Image("empty_image_placeholder_img")
                        .resizable()
                }
            }
            .frame(height: proxy.size.height/3.5, alignment: .center)

            List {
                KeyValueTextRow(keyText: "Name", valueText: model.name)
                KeyValueTextRow(keyText: "Weight", valueText: model.weight.formatted())
                KeyValueTextRow(keyText: "Height", valueText: model.height.formatted())
                KeyValueTextRow(keyText: "Types", valueText: model.types)
                KeyValueTextRow(keyText: "Base Experience", valueText: model.baseExperience.formatted())
                KeyValueTextRow(keyText: "CatchedDate", valueText: model.catchedDate.formatted())
            }
        }
    }
}

#if DEBUG
struct PokemonDetail_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(viewModel: .init(container: .preview, pokemoneId: 0))
    }
}
#endif
