//
//  LeftToRightGradient.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import SwiftUI

struct LeftToRightGradient: ViewModifier {
    
    let colors: [Color]
    
    init(colors: Color...) {
        self.colors = colors
    }
    
    init(colors: [Color]) {
        self.colors = colors
    }
    
    func body(content: Content) -> some View {
        content
            .background(LinearGradient(colors: colors,
                                       startPoint: .leading,
                                       endPoint: .trailing))
    }
}
