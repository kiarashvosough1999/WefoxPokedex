//
//  FancyButton.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import SwiftUI
import Combine

struct FancyButton: View {
    
    // MARK: - DataSource
    
    private let action: (() -> Void)?
    
    private let title: String
    
    private let isDisabled: Bool
    
    let inspection = Inspection<Self>()
    
    init(title: String, isDisabled: Bool = false, action: @escaping (() -> Void)) {
        self.action = action
        self.title = title
        self.isDisabled = isDisabled
    }
    
    var body: some View {
        Button {
            action?()
        } label: {
            Text(title)
                .bold()
                .foregroundColor(Color.white)
                .padding()
                .frame(maxWidth: .infinity)
        }
        .leftToRightGradient(with: Color.cyan, Color.indigo)
        .cornerRadius(10)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
}

#if DEBUG
struct FancyButton_Previews: PreviewProvider {
    static var previews: some View {
        FancyButton(title: "Test", action: {})
    }
}
#endif
