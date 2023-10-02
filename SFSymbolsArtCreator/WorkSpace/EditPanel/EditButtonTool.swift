//
//  EditButtonTool.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SFUserFriendlySymbols
import SwiftUI

struct EditButtonToolFeature: Reducer {
    struct State: Equatable {
        var flipType: FlipType
        var fontWight: Font.Weight
        var rotationDegree: Double
    }
    
    enum Action: Equatable {
        case flipHorizontalButtonTapped
        case flipVerticalButtonTapped
        case fontWeightDownButtonTapped
        case fontWeightUpButtonTapped
        case rotateButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .flipHorizontalButtonTapped:
                return .none
            case .flipVerticalButtonTapped:
                return .none
            case .fontWeightDownButtonTapped:
                return .none
            case .fontWeightUpButtonTapped:
                return .none
            case .rotateButtonTapped:
                return .none
            }
        }
    }
}

struct EditButtonToolView: View {
    
    let store: StoreOf<EditButtonToolFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
                
                HStack {
                    VerticalSymbolLabelButton(
                        title: "Flip Horizontal",
                        symbol: .arrowLeftAndRightRighttriangleLeftRighttriangleRightFill
                    ) {
                        viewStore.send(.flipHorizontalButtonTapped)
                    }
                    .frame(width: 88, height: 44)
                    
                    VerticalSymbolLabelButton(
                        title: "Flip Vertical",
                        symbol: .arrowUpAndDownRighttriangleUpRighttriangleDownFill
                    ) {
                        viewStore.send(.flipVerticalButtonTapped)
                    }
                    .frame(width: 88, height: 44)
                    
                    VerticalSymbolLabelButton(
                        title: "Rotate 45°",
                        symbol: .rotateRightFill
                    ) {
                        viewStore.send(.rotateButtonTapped)
                    }
                    .frame(width: 88, height: 44)
                    
                    VerticalLabelButton(title: "Up Weight", action: {
                        viewStore.send(.fontWeightUpButtonTapped)
                    }, content: {
                        HStack(spacing: 0) {
                            Image(symbol: .arrowUp)
                                .font(.system(size: 16))
                            Image(symbol: .bold)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                    })
                    .frame(width: 88, height: 44)
                    
                    VerticalLabelButton(title: "Down Weight", action: {
                        viewStore.send(.fontWeightDownButtonTapped)
                    }, content: {
                        HStack(spacing: 0) {
                            Image(symbol: .arrowDown)
                                .font(.system(size: 16))
                            Image(symbol: .bold)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                    })
                    .frame(width: 88, height: 44)
                }
                .bold()
                .foregroundStyle(.white)
                .padding()
            }
    }
}

#Preview {
    EditButtonToolView(store: .init(
        initialState: EditButtonToolFeature.State(
            flipType: .none,
            fontWight: .regular,
            rotationDegree: 0)
    ) {
        EditButtonToolFeature()
    })
    .background {
        RoundedRectangle(cornerRadius: 8)
            .fill(.heavyDarkGray)
    }
}

struct VerticalSymbolLabelButton: View {
    let title: LocalizedStringKey
    let symbol: SFSymbols
    let action: () -> Void
    
    var body: some View {
        VerticalLabelButton(title: title) {
            action()
        } content: {
            Image(symbol: symbol)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }
    }
}

struct VerticalLabelButton<Content: View>: View {
    
    let title: LocalizedStringKey
    let action: () -> Void
    let content: Content

    init(title: LocalizedStringKey,
         action: @escaping () -> Void,
         @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
        self.title = title
    }
    
    var body: some View {
        
        VStack {
            Button(action: {
                action()
            }, label: {
                content
            })
            
            Text(title)
                .font(.caption)
        }
    }
}

#Preview {
    Color.heavyDarkGray
        .overlay {
            VerticalLabelButton(title: "Flip Horizontal", action: {
            }, content: {
                Image(symbol: .arrowLeftAndRightRighttriangleLeftRighttriangleRightFill)
                    .font(.system(size: 32))
            })
            .frame(width: 88, height: 44)
        }
}
