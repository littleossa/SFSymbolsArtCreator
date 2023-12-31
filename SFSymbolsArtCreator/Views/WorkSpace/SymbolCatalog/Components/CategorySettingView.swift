//
//  CategorySettingView.swift
//  SFSymbolsArtCreator
//
//

import SFUserFriendlySymbols
import SwiftUI

struct CategorySettingView: View {
    
    @Binding var selectedCategory: SFSymbols.Category
    
    var body: some View {
        
        AccordionSettingView(title: "Category") {
                        
            Menu {
                ForEach(SFSymbols.Category.allCases) { category in
                    
                    Button(action: {
                        selectedCategory = category
                    }, label: {
                        Label(
                            title: { Text(category.rawValue) },
                            icon: { Image(symbol: category.symbol) }
                        )
                    })
                }
                
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.paleGray)
                    .overlay {
                        Label(
                            title: { Text(selectedCategory.rawValue) },
                            icon: { Image(symbol: selectedCategory.symbol) }
                        )
                        .font(.title3)
                    }
            }
            .frame(height: 48)
            .padding(.bottom)
            .padding(.trailing)
        }
    }
}

#Preview {
    Color.heavyDarkGray
        .overlay {
            CategorySettingView(selectedCategory: .constant(.all))
                .frame(width: 284, height: 500)
        }
}

extension SFSymbols.Category: Identifiable {
    public var id: String {
        return self.rawValue
    }
    
    public var symbol: SFSymbols {
        switch self {
        case .all:
            return .squareGrid2X2
        case .new:
            return  .sparkle
        case .multicolor:
            return .paintpalette
        case .communication:
            return .message
        case .weather:
            return .cloudSun
        case .objectAndTools:
            return .folder
        case .devices:
            return .desktopcomputer
        case .gaming:
            return .gamecontroller
        case .connectivity:
            return .antennaRadiowavesLeftAndRight
        case .transportation:
            return .carFill
        case .human:
            return .personCropCircle
        case .nature:
            return .leaf
        case .editing:
            return .sliderHorizontal3
        case .textFormatting:
            return .textformat
        case .media:
            return .playpause
        case .keyboard:
            return .command
        case .commerce:
            return .cart
        case .time:
            return .timer
        case .health:
            return .heart
        case .shapes:
            return .squareOnCircle
        case .arrows:
            return .arrowRight
        case .indices:
            return .aCircle
        case .math:
            return .xSquareroot
        }
    }
}
