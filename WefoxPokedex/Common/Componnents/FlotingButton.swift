//
//  FlotingButton.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/5/22.
//

import SwiftUI

struct FlotingButton<ImageView: View>: ViewModifier {
    
    private let color: Color
    private let image: () -> ImageView
    private let action: () -> Void
    private var size: CGFloat = 60
    private var margin: CGFloat = 15
    
    init(color: Color, @ViewBuilder image: @escaping () -> ImageView, action: @escaping () -> Void) {
        self.color = color
        self.image = image
        self.action = action
    }
    
    init(color: Color, image: ImageView, action: @escaping () -> Void) {
        self.color = color
        self.image = {
            image
        }
        self.action = action
    }
    
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            ZStack {
                Color.clear
                content
                button(proxy)
            }
        }
    }
    
    @ViewBuilder private func button(_ proxy: GeometryProxy) -> some View {
        image()
            .imageScale(.large)
            .frame(width: size, height: size)
            .background(Circle().fill(color))
            .foregroundColor(.white)
            .shadow(color: .gray, radius: 2, x: 1, y: 1)
            .onTapGesture(perform: action)
            .offset(x: (proxy.size.width - size) / 2 - margin,
                    y: (proxy.size.height - size) / 2 - margin)
    }
}

// MARK: - Modifiers

extension View {
    
    func floatingButton<ImageView: View>( color: Color, image: ImageView, action: @escaping () -> Void) -> some View {
        self.modifier(FlotingButton(color: color,
                                    image: image,
                                    action: action))
    }
    
    func floatingButton<ImageView: View>(color: Color, @ViewBuilder image: @escaping () -> ImageView, action: @escaping () -> Void) -> some View {
        self.modifier(FlotingButton(color: color,
                                    image: image,
                                    action: action))
    }
}
