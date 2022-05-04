//
//  ContentView.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/3/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private(set) var viewModel: ViewModel
    
    @State var dsd: Bool = true
    
    var body: some View {
        Group {
            SearchPokemon(viewModel: SearchPokemon.ViewModel(container: viewModel.container,
                                                             isDisplayed: $dsd))
        }
        .background(Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentView.ViewModel(container: .preview))
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
