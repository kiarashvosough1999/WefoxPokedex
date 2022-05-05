//
//  PoekemonesItemView.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/5/22.
//

import SwiftUI

struct PoekemonesItemView: View {
    
    let imageData: Data
    let name: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .overlay(Circle().stroke(Color.red, lineWidth: 5))
            }
            Text(name)
                .bold()
                .font(.title2)
        }
    }
}

struct PoekemonesItemView_Previews: PreviewProvider {
    static var previews: some View {
        PoekemonesItemView(imageData: Data(), name: "Test")
    }
}
