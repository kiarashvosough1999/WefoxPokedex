//
//  View++Extensions.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    
    @inlinable func padding(vertical: CGFloat) -> some View {
        padding(EdgeInsets(top: vertical, leading: 0, bottom: vertical, trailing: 0))
    }
    
    @inlinable func padding(horizontal: CGFloat) -> some View {
        padding(EdgeInsets(top: 0, leading: horizontal, bottom: 0, trailing: horizontal))
    }
    
    @inlinable func padding(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) -> some View {
        padding(EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing))
    }
    
    func leftToRightGradient(with colors: Color...) -> some View {
        self.modifier(LeftToRightGradient(colors: colors))
    }
}
