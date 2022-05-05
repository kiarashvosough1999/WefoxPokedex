//
//  MeteredZStack.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import SwiftUI

struct MeteredVStack<Content>: View where Content: View  {
    
    let alignment: HorizontalAlignment
    let spacing: CGFloat
    let content: (GeometryProxy) -> Content
    
    internal init(alignment: HorizontalAlignment = .center, spacing: CGFloat = 0, @ViewBuilder content: @escaping (GeometryProxy) -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }
    
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: alignment, spacing: spacing) {
                content(proxy)
            }
        }
    }
}
