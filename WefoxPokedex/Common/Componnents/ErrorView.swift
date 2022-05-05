//
//  ErrorView.swift
//  WefoxPokedex
//
//  Created by Kiarash Vosough on 5/4/22.
//

import SwiftUI

struct ErrorView: View {
    
    private let error: Error
    private let retryAction: () -> Void
    
    init(error: Error, retryAction: @escaping () -> Void) {
        self.error = error
        self.retryAction = retryAction
    }

    var body: some View {
        VStack {
            Text("An Error Occured")
                .font(.title)
            Text(error.localizedDescription)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40).padding()
            Button(action: retryAction) {
                Text("Retry").bold()
            }
        }
    }
}

#if DEBUG
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error:
                    NSError(domain: "",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "Something went wrong"]),
                  retryAction: { })
    }
}
#endif
