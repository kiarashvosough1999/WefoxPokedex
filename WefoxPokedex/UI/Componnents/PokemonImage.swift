//
//  PokemonImage.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import SwiftUI

struct PokemonImage: View {

    private let imageURL: URL?
    private let proxyHeight: CGFloat
    
    init(imageURL: URL?, proxyHeight: CGFloat) {
        self.imageURL = imageURL
        self.proxyHeight = proxyHeight
    }

    var body: some View {
        AsyncImage(url: imageURL) { image in
            image
                .resizable()
                .frame(height: proxyHeight/3.5, alignment: .center)
        } placeholder: {
            Image("empty_image_placeholder_img")
                .resizable()
                .frame(height: proxyHeight/3.5, alignment: .center)
        }
    }
}
