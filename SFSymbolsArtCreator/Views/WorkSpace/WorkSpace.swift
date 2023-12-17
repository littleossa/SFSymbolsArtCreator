//
//  WorkSpace.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

// MARK: - Initializer
extension WorkSpaceFeature.State {
    
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

struct WorkSpaceFeature: Reducer {
    struct State: Equatable {
        var artCanvasState: ArtCanvasFeature.State
        var colorToolState: ColorToolFeature.State
        var drawToolState: DrawToolFeature.State
        var editPanelState: EditPanelFeature.State?
        var layerPanelState: LayerPanelFeature.State?
        var menuToolState: MenuToolFeature.State
        var symbolCatalogState: SymbolCatalogFeature.State
        
        fileprivate mutating func clearLayerPanel() {
            layerPanelState = nil
            drawToolState.layerPanelIsPresented = false
        }
        
        fileprivate mutating func setEditSymbol(appearance: ArtSymbolAppearance) {
            drawToolState.renderingType = appearance.renderingType
            colorToolState.primaryColor = appearance.primaryColor
            colorToolState.secondaryColor = appearance.secondaryColor
            colorToolState.tertiaryColor = appearance.tertiaryColor
            
            let editFormType = artCanvasState.editFormType
            editPanelState = .init(appearance: appearance,
                                   editFormType: editFormType)
        }
    }
    
    enum Action: Equatable {
        case artCanvas(ArtCanvasFeature.Action)
        case colorTool(ColorToolFeature.Action)
        case drawTool(DrawToolFeature.Action)
        case editPanel(EditPanelFeature.Action)
        case layerPanel(LayerPanelFeature.Action)
        case menuTool(MenuToolFeature.Action)
        case symbolCatalog(SymbolCatalogFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .artCanvas(.delegate(.editingAppearanceChanged(appearance))):
                
                guard let editPanel = state.editPanelState
                else { return .none }
                state.editPanelState = .init(
                    appearance: appearance,
                    editFormType: editPanel.editFormType,
                    isDisplayAllEditToolOptions: editPanel.isDisplayAllEditToolOptions
                )
                    
                return .none
                
            case .artCanvas:
                return .none
                
            case let .colorTool(.delegate(.canvasColorChanged(color))):
                state.artCanvasState.canvasColor = color
                state.symbolCatalogState.catalogSettingsState.currentCanvasColor = color
                
                let isCanvasColor = state.symbolCatalogState.catalogSettingsState.catalogBackgroundColorItem.isCanvasColor
                if isCanvasColor {
                    state.symbolCatalogState.catalogItemListState.backgroundColor = color
                }
                return .none
                
            case let .colorTool(.delegate(.primaryColorChanged(color))):
                state.artCanvasState.editingSymbolAppearance?.primaryColor = color
                return .none
                
            case let .colorTool(.delegate(.secondaryColorChanged(color))):
                state.artCanvasState.editingSymbolAppearance?.secondaryColor = color
                return .none
                
            case let .colorTool(.delegate(.tertiaryColorChanged(color))):
                state.artCanvasState.editingSymbolAppearance?.tertiaryColor = color
                return .none
                
            case .colorTool:
                return .none
                
            case let .drawTool(.renderingTypeChanged(type)):
                
                state.clearLayerPanel()

                state.colorToolState.renderingType = type
                state.artCanvasState.editingSymbolAppearance?.renderingType = type
                
                switch type {
                    
                case .hierarchical, .monochrome, .multiColor:
                    state.colorToolState.secondaryColor = .clear
                    state.colorToolState.tertiaryColor = .clear
                    state.artCanvasState.editingSymbolAppearance?.secondaryColor = .clear
                    state.artCanvasState.editingSymbolAppearance?.tertiaryColor = .clear
               
                case .palette:
                    state.colorToolState.secondaryColor = .accentColor
                    state.colorToolState.tertiaryColor = .white
                    state.artCanvasState.editingSymbolAppearance?.secondaryColor = .accentColor
                    state.artCanvasState.editingSymbolAppearance?.tertiaryColor = .white
                }
                
                return .none
                
            case let .drawTool(.delegate(.editButtonToggled(isEditMode))):
                
                state.clearLayerPanel()
                
                if isEditMode,
                   let firstSymbol = state.artCanvasState.artSymbols.first {
                    
                    state.artCanvasState.editSymbolID = firstSymbol.id
                    
                    let appearance = firstSymbol.appearance
                    state.setEditSymbol(appearance: appearance)
                    
                } else {
                    state.artCanvasState.editSymbolID = nil
                    state.editPanelState = nil
                }
                return .none
            
            case let .drawTool(.delegate(.layerButtonToggled(layerIsPresented))):
                
                if layerIsPresented {
                    state.layerPanelState = .init(artSymbols: state.artCanvasState.artSymbols,
                                                  editSymbolID: state.artCanvasState.editSymbolID)
                } else {
                    state.clearLayerPanel()
                }
                
                return .none
                
            case .drawTool:
                return .none
                                
            case let .editPanel(.delegate(.editFormTypeChanged(editFormType))):
                state.artCanvasState.editFormType = editFormType
                return .none
                
            case let .editPanel(.editButtonTool(.delegate(.degreesRotated(degrees)))):
                state.artCanvasState.editingSymbolAppearance?.rotationDegrees = degrees
                return .none
                
            case let .editPanel(.editButtonTool(.delegate(.flipTypeChanged(flipType)))):
                state.artCanvasState.editingSymbolAppearance?.flipType = flipType
                return .none
                
            case let .editPanel(.editButtonTool(.delegate(.fontWeightChanged(weight)))):
                state.artCanvasState.editingSymbolAppearance?.weight = weight
                return .none
                
            case let .editPanel(.editStepperTool(.delegate(.degreesValueChanged(degrees)))):
                state.artCanvasState.editingSymbolAppearance?.rotationDegrees = degrees
                return .none
                
            case let .editPanel(.editStepperTool(.delegate(.heightValueChanged(height)))):
                state.artCanvasState.editingSymbolAppearance?.height = height
                return .none
                
            case let .editPanel(.editStepperTool(.delegate(.positionValueChanged(position)))):
                state.artCanvasState.editingSymbolAppearance?.position = position
                return .none
                
            case let .editPanel(.editStepperTool(.delegate(.widthValueChanged(width)))):
                state.artCanvasState.editingSymbolAppearance?.width = width
                return .none
                
            case .editPanel:
                return .none
                
            case .layerPanel(.overlayTapped):
                state.clearLayerPanel()
                return .none
                
            case let  .layerPanel(.artSymbolsOrderMoved(sourceIndex, destinationOrder)):
                state.artCanvasState.artSymbols.move(fromOffsets: sourceIndex, toOffset: destinationOrder)
                return .none
                
            case let .layerPanel(.delegate(.hideButtonTapped(id))):
                state.artCanvasState.artSymbols[id: id]?.appearance.isHidden.toggle()
                state.layerPanelState?.artSymbols = state.artCanvasState.artSymbols
                return .none
                
            case .layerPanel(.delegate(.currentEditSymbolLayerTapped)):
                state.artCanvasState.editSymbolID = nil
                state.layerPanelState?.editSymbolID = nil
                state.editPanelState = nil
                return .none
                
            case let .layerPanel(.delegate(.editSymbolIDChanged(id))):
                state.artCanvasState.editSymbolID = id
                
                guard let appearance = state.artCanvasState.editingSymbolAppearance
                else { return .none }
                
                state.setEditSymbol(appearance: appearance)
                return .none
                
            case let .layerPanel(.deleteButtonTapped(id)):
                state.artCanvasState.artSymbols.remove(id: id)
                state.layerPanelState?.artSymbols = state.artCanvasState.artSymbols
                return .none
            
            case let .layerPanel(.duplicateButtonTapped(id)):
                guard let sourceSymbol = state.artCanvasState.artSymbols[id: id],
                      let index = state.artCanvasState.artSymbols.index(id: id)
                else { return .none }
                         
                let uuid = UUID()
                let duplicatedSymbol: ArtSymbolFeature.State = .init(
                    id: uuid,
                    appearance: sourceSymbol.appearance
                )
                state.artCanvasState.artSymbols.insert(duplicatedSymbol, at: index)
                state.artCanvasState.editSymbolID = uuid
                state.layerPanelState?.editSymbolID = uuid
                state.layerPanelState?.artSymbols = state.artCanvasState.artSymbols
                return .none
                
            case .layerPanel:
                return .none
                
            case .menuTool:
                return .none
            case let .symbolCatalog(.catalogItemList(.delegate(.catalogItemSelected(item)))):
                let uuid = UUID()
                
                let artSymbol: ArtSymbolFeature.State = .init(
                    id: uuid,
                    appearance: .init(
                        catalogItem: item,
                        width: 60,
                        height: 60,
                        position: CGPoint(x: 50, y: 50)
                    )
                )
                state.artCanvasState.artSymbols.insert(artSymbol, at: 0)
                state.artCanvasState.editSymbolID = uuid
                state.drawToolState.isEditMode = true
                
                state.setEditSymbol(appearance: artSymbol.appearance)
                return .none
                
            case .symbolCatalog:
                return .none
            }
        }
        .ifLet(\.editPanelState, action: /Action.editPanel) {
            EditPanelFeature()
        }
        .ifLet(\.layerPanelState, action: /Action.layerPanel) {
            LayerPanelFeature()
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
            
            ZStack {
                
                HStack(spacing:0) {
                    SymbolCatalogView(store: store.scope(
                        state: \.symbolCatalogState,
                        action: WorkSpaceFeature.Action.symbolCatalog)
                    )
                    
                    GeometryReader { geometry in
                        
                        ZStack(alignment: .center) {
                            
                            Rectangle()
                                .fill(.black.gradient)
                                .ignoresSafeArea(edges: .bottom)
                            
                            ArtCanvasView(store: store.scope(
                                state: \.artCanvasState,
                                action: WorkSpaceFeature.Action.artCanvas)
                            )
                            .frame(width: geometry.size.width * 0.7,
                                   height: geometry.size.width * 0.7)
                            
                            VStack {
                                Spacer()
                                
                                IfLetStore(self.store.scope(state: \.editPanelState,
                                                            action: WorkSpaceFeature.Action.editPanel)) {
                                    EditPanelView(store: $0)
                                }
                            }
                        }
                    }
                    
                    ColorToolBar(store: store.scope(
                        state: \.colorToolState,
                        action: WorkSpaceFeature.Action.colorTool)
                    )
                }
                
                IfLetStore(self.store.scope(state: \.layerPanelState,
                                            action: WorkSpaceFeature.Action.layerPanel)) {
                    LayerPanelView(store: $0)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    WorkSpaceView(store: .init(
        initialState: WorkSpaceFeature.State()) {
                WorkSpaceFeature()
            }
    )
}
