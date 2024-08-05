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
        var backgroundColor: Color = .white
        var inputModel: TextViewInputModel = .default
        var limitCount: Int = 999999
        var limitLine: Int = 999999
    }
    
    enum TextAction: Equatable {
        case viewOption(ViewOptionAction)
        
        case style(StyleAction)
    }
    
    enum ViewOptionAction: Equatable {
        case updateColor(Color)
        case updateScrollEnabled(Bool)
        case updateEditable(Bool)
        case updateSelectable(Bool)
    }
    
    enum StyleAction: Equatable {
        case updateInputModel(TextViewInputModel)
        
        case updateLimitCount(Int)
        case updateLimitLine(Int)
    }
    
    @Published private var state: TextState = .init()
    
    func callAsFunction<V>(_ keyPath: KeyPath<TextState, V>) -> V where V : Equatable {
        return state[keyPath: keyPath]
    }
    
    func action(_ action: TextAction) {
        switch action {
        case .viewOption(let action):
            optionAction(action)
        case .style(let action):
            styleAction(action)
        }
    }
}

private extension TextViewModel {
    
    private func optionAction(_ action: ViewOptionAction) {
        switch action {
        case .updateColor(let color):
            update(\.backgroundColor, value: color)
            
        case .updateScrollEnabled(let state):
            update(\.isScrollEnabled, value: state)
            
        case .updateEditable(let state):
            update(\.isEditable, value: state)
            
        case .updateSelectable(let state):
            update(\.isSelectable, value: state)
        }
    }
    
}

private extension TextViewModel {
    
    private func styleAction(_ action: StyleAction) {
        switch action {
        case .updateInputModel(let model):
            update(\.inputModel, value: model)
            
        case .updateLimitCount(let count):
            update(\.limitCount, value: count)
            
        case .updateLimitLine(let line):
            update(\.limitLine, value: line)
        }
    }
}

private extension TextViewModel {
    func update<V>(_ keyPath: WritableKeyPath<State, V>, value: V) where V: Equatable {
        state[keyPath: keyPath] = value
    }
}
