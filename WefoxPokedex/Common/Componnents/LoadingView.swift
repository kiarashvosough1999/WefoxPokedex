//
//  LoadingView.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/5/22.
//

import SwiftUI

struct LoadingView: View {

    private var cancelLoadingAction: (() -> Void)?
    let inspection = Inspection<Self>()
    
    init(cancelLoadingAction: (() -> Void)? = nil) {
        self.cancelLoadingAction = cancelLoadingAction
    }

    var body: some View {
        VStack {
            ActivityIndicatorView()
            if cancelLoadingAction.isNotNil {
                Button {
                    cancelLoadingAction?()
                } label: {
                    Text("Cancel loading")
                }
            }
        }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
