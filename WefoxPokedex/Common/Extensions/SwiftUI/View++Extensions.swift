//
//  View++Extensions.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    
    func leftToRightGradient(with colors: Color...) -> some View {
        self.modifier(LeftToRightGradient(colors: colors))
    }
}
