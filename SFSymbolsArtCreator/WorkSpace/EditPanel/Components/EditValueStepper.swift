//
//  EditValueStepper.swift
//  SFSymbolsArtCreator
//
//

import SFUserFriendlySymbols
import SwiftUI

struct EditValueStepper: View {
    
    let title: LocalizedStringKey
    let incrementAction: () -> Void
    let decrementAction: () -> Void
    
    var body: some View {
        VStack(alignment: .center) {
            
            Text(title)
                .bold()
            
            Stepper(title) {
                incrementAction()
            } onDecrement: {
                decrementAction()
            }
            .labelsHidden()
            .background(RoundedRectangle(cornerRadius: 6)
                .fill(.paleGray)
                .frame(width: 94, height: 28))

        }
        .foregroundStyle(.white)
    }
}

#Preview {
    Color.heavyDarkGray
        .overlay {
            EditValueStepper(title: "width",
                             incrementAction: {},
                             decrementAction: {}
            )
            .frame(width: 94)
        }
}
