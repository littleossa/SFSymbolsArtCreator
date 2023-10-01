//
//  WorkSpace.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct WorkSpaceFeature: Reducer {
    struct State: Equatable {
        var artCanvasState: ArtCanvasFeature.State
        var colorToolState: ColorToolFeature.State
        var drawToolState: DrawToolFeature.State
        var menuToolState: MenuToolFeature.State
        var symbolCatalogState: SymbolCatalogFeature.State
        
        init(renderingType: RenderingType = .monochrome,
             primaryColor: Color = .black,
             secondaryColor: Color = .accentColor,
             tertiaryColor: Color = .white,
             canvasColor: Color = .white,
             editFormType: EditFormType = .freeForm
        ) {
            self.artCanvasState = .init(artSymbols: [],
                                        canvasColor: canvasColor,
                                        editFormType: editFormType)
            self.colorToolState = .init(renderingType: renderingType,
                                        canvasColor: canvasColor,
                                        primaryColor: primaryColor,
                                        secondaryColor: secondaryColor,
                                        tertiaryColor: tertiaryColor)
            self.drawToolState = .init(renderingType: renderingType)
            self.menuToolState = .init()
            self.symbolCatalogState = .init(renderingType: renderingType,
                                            primaryColor: primaryColor,
                                            secondaryColor: secondaryColor,
                                            tertiaryColor: tertiaryColor,
                                            canvasColor: canvasColor)
        }
    }
    
    enum Action: Equatable {
        case artCanvas(ArtCanvasFeature.Action)
        case colorTool(ColorToolFeature.Action)
        case drawTool(DrawToolFeature.Action)
        case menuTool(MenuToolFeature.Action)
        case symbolCatalog(SymbolCatalogFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .artCanvas:
                return .none
                
            case let .colorTool(.delegate(.changeCanvasColor(color))):
                state.artCanvasState.canvasColor = color
                state.symbolCatalogState.catalogSettingsState.currentCanvasColor = color
                
                let isCanvasColor = state.symbolCatalogState.catalogSettingsState.catalogBackgroundColorItem.isCanvasColor
                if isCanvasColor {
                    state.symbolCatalogState.catalogItemListState.backgroundColor = color
                }
                return .none
                
            case let .colorTool(.delegate(.changePrimaryColor(color))):
                state.symbolCatalogState.catalogItemListState.primaryColor = color
                return .none
                
            case let .colorTool(.delegate(.changeSecondaryColor(color))):
                state.symbolCatalogState.catalogItemListState.secondaryColor = color
                return .none
                
            case let .colorTool(.delegate(.changeTertiaryColor(color))):
                state.symbolCatalogState.catalogItemListState.tertiaryColor = color
                return .none
                
            case .colorTool:
                return .none
                
            case let .drawTool(.delegate(.changeRenderingType(renderingType))):
                state.colorToolState.renderingType = renderingType
                state.symbolCatalogState.catalogItemListState.renderingType = renderingType
                
                switch renderingType {
                    
                case .hierarchical, .monochrome, .multiColor:
                    state.colorToolState.secondaryColor = .clear
                    state.colorToolState.tertiaryColor = .clear
                    state.symbolCatalogState.catalogItemListState.secondaryColor = .clear
                    state.symbolCatalogState.catalogItemListState.tertiaryColor = .clear
               
                case .palette:
                    state.colorToolState.secondaryColor = .accentColor
                    state.colorToolState.tertiaryColor = .white
                    state.symbolCatalogState.catalogItemListState.secondaryColor = .accentColor
                    state.symbolCatalogState.catalogItemListState.tertiaryColor = .white
                }
                
                return .none
            case .drawTool:
                return .none
                
            case .menuTool:
                return .none
            case let .symbolCatalog(.delegate(.selectSymbol(symbol))):
                let uuid = UUID()
                state.artCanvasState.artSymbols.insert(.init(id: uuid,
                                                             symbolName: symbol.rawValue,
                                                             width: 60,
                                                             height: 60,
                                                             weight: .regular,
                                                             position: CGPoint(x: 50, y: 50),
                                                             renderingType: .monochrome,
                                                             primaryColor: .black,
                                                             secondaryColor: .accentColor,
                                                             tertiaryColor: .white),
                                                       at: 0)
                state.artCanvasState.editSymbolID = uuid
                return .none
            case .symbolCatalog:
                return .none
            }
        }
        Scope(state: \.artCanvasState, action: /Action.artCanvas) {
            ArtCanvasFeature()
        }
        Scope(state: \.colorToolState, action: /Action.colorTool) {
            ColorToolFeature()
        }
        Scope(state: \.drawToolState, action: /Action.drawTool) {
            DrawToolFeature()
        }
        Scope(state: \.menuToolState, action: /Action.menuTool) {
            MenuToolFeature()
        }
        Scope(state: \.symbolCatalogState, action: /Action.symbolCatalog) {
            SymbolCatalogFeature()
        }
    }
}

struct WorkSpaceView: View {
    
    let store: StoreOf<WorkSpaceFeature>
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    MenuToolBar(store: store.scope(
                        state: \.menuToolState,
                        action: WorkSpaceFeature.Action.menuTool)
                    )
                    
                    DrawToolBar(store: store.scope(
                        state: \.drawToolState,
                        action: WorkSpaceFeature.Action.drawTool)
                    )
                }
                Divider()
                    .background(.black.opacity(0.9))
            }
            
            HStack(spacing:0) {
                SymbolCatalogView(store: store.scope(
                    state: \.symbolCatalogState,
                    action: WorkSpaceFeature.Action.symbolCatalog)
                )
                                    
                GeometryReader { geometry in
                    
                    ZStack(alignment: .center) {
                        
                        Rectangle()
                            .fill(.black)
                            .opacity(0.9)
                            .blur(radius: 2)
                            .ignoresSafeArea(edges: .bottom)
                        
                        ArtCanvasView(store: store.scope(
                            state: \.artCanvasState,
                            action: WorkSpaceFeature.Action.artCanvas)
                        )
                        .frame(width: geometry.size.width * 0.7,
                               height: geometry.size.width * 0.7)
                    }
                }
                
                ColorToolBar(store: store.scope(
                    state: \.colorToolState,
                    action: WorkSpaceFeature.Action.colorTool)
                )
            }
        }
    }
}

#Preview {
    WorkSpaceView(store: .init(
        initialState: WorkSpaceFeature.State()) {
                WorkSpaceFeature()
            }
    )
}
