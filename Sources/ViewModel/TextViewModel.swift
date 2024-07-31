//
//  TextViewModel.swift
//  GabTextView
//
//  Created by Gab on 2024/07/30.
//

import SwiftUI

protocol TextViewFeatures {
    associatedtype State: Equatable
    associatedtype Action: Equatable
    
    func callAsFunction<V: Equatable>(_ keyPath: KeyPath<State, V>) -> V
    
    func action(_ action: Action)
}

class TextViewModel: ObservableObject, TextViewFeatures {
    typealias State = TextState
    typealias Action = TextAction
    
    struct TextState: Equatable {
        var isScrollEnabled: Bool = true
        var isEditable: Bool = true
        var isSelectable: Bool = true
        var backgroundColor: Color = .gray
        var inputModel: TextViewInputModel = .default
        var placeHolderMode: Bool = false
        var isShowPlaceHolder: Bool = false
    }
    
    enum TextAction: Equatable {
        case updateColor(Color)
        case updateScrollEnabled(Bool)
        case updateEditable(Bool)
        case updateSelectable(Bool)
        case updateInputModel(TextViewInputModel)
        case updatePlaceHolderMode(Bool)
        case updateShowPlaceHolder(Bool)
    }
    
    @Published private var state: TextState = .init()
    
    func callAsFunction<V>(_ keyPath: KeyPath<TextState, V>) -> V where V : Equatable {
        return state[keyPath: keyPath]
    }
    
    func action(_ action: TextAction) {
        switch action {
        case .updateColor(let color):
            update(\.backgroundColor, value: color)
            
        case .updateScrollEnabled(let state):
            update(\.isScrollEnabled, value: state)
            
        case .updateEditable(let state):
            update(\.isEditable, value: state)
            
        case .updateSelectable(let state):
            update(\.isSelectable, value: state)
            
        case .updateInputModel(let model):
            update(\.inputModel, value: model)
            
        case .updatePlaceHolderMode(let state):
            update(\.placeHolderMode, value: state)
            
        case .updateShowPlaceHolder(let state):
            update(\.isShowPlaceHolder, value: state)
        }
    }
}

private extension TextViewModel {
    func update<V>(_ keyPath: WritableKeyPath<State, V>, value: V) where V: Equatable {
        state[keyPath: keyPath] = value
    }
}
