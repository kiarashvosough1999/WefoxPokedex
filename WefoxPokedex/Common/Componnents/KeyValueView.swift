//
//  KeyValueView.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import SwiftUI

struct KeyValueTextRow: View {
    
    // MARK: - States
    
    @State fileprivate var keyFont: Font = .title2
    @State fileprivate var valueFont: Font = .body
    
    @State fileprivate var keyColor: Color = .secondary
    @State fileprivate var valueColor: Color = .red.opacity(0.75)
    
    // MARK: - DataSources
    
    private var keyText: String
    private var valueText: String
    
    internal init(keyText: String, valueText: String) {
        self.keyText = keyText
        self.valueText = valueText
    }
    
    
    var body: some View {
        HStack {
            Text(keyText)
                .font(keyFont)
                .foregroundColor(keyColor)
            Spacer()
            Text(valueText)
                .font(valueFont)
                .foregroundColor(valueColor)
        }
    }
}

extension View where Self == KeyValueTextRow {
    
    func keyFont(_ font: Font) -> Self {
        self.keyFont = font
        return self
    }
    
    func valueFont(_ font: Font) -> Self {
        self.valueFont = font
        return self
    }
    
    func keyColor(_ color: Color) -> Self {
        self.keyColor = color
        return self
    }
    
    func valueColor(_ color: Color) -> Self {
        self.valueColor = color
        return self
    }
}


#if DEBUG
struct KeyValueView_Previews: PreviewProvider {
    static var previews: some View {
        KeyValueTextRow(keyText: "Text", valueText: "Text")
    }
}
#endif
