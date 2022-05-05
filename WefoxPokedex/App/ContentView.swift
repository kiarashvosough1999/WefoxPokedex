//
//  ContentView.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        Group {
            PokemonBagListView(viewModel: PokemonBagListView.ViewModel(container: viewModel.container))
        }
        .background(Color.white)
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        
        let container: DIContainer
        
        init(container: DIContainer) {
            self.container = container
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentView.ViewModel(container: .preview))
    }
}
#endif
