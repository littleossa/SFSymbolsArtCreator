//
//  EditValueStepper.swift
//  SFSymbolsArtCreator
//
//

import SFUserFriendlySymbols
import SwiftUI

struct EditValueStepper: View {
    
    let symbol: SFSymbols
    let title: LocalizedStringKey
    let incrementAction: () -> Void
    let decrementAction: () -> Void
    
    var body: some View {
        VStack(alignment: .center) {
            Image(symbol: symbol)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            Text(title)
                .font(.caption)
            
            Stepper(title) {
                incrementAction()
            } onDecrement: {
                decrementAction()
            }
            .labelsHidden()
            .background(RoundedRectangle(cornerRadius: 6)
                .fill(.white)
                .frame(width: 94, height: 32))

        }
        .bold()
        .foregroundStyle(.white)
    }
}

#Preview {
    Color.heavyDarkGray
        .overlay {
            EditValueStepper(symbol: .arrowLeftCircleFill,
                             title: "width",
                             incrementAction: {},
                             decrementAction: {}
            )
            .frame(width: 94)
        }
}
