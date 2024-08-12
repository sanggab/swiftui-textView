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
    
    struct ViewOptionState: Equatable {
        var isScrollEnabled: Bool = true
        var isEditable: Bool = true
        var isSelectable: Bool = true
        var backgroundColor: Color = .white
        var contentPriority: TextViewContentPriority = .default
        var textContainerInset: UIEdgeInsets = .zero
    }
    
    struct ViewStyleState: Equatable {
        var appearance: TextViewAppearanceModel = .default
        var limitCount: Int = 999999
        var limitLine: Int = 999999
    }
    
    enum ViewOptionAction: Equatable {
        case updateColor(Color)
        case updateScrollEnabled(Bool)
        case updateEditable(Bool)
        case updateSelectable(Bool)
        case updateSetContentCompressionResistancePriority(UILayoutPriority, NSLayoutConstraint.Axis)
        case updateTextContainerInset(UIEdgeInsets)
    }
    
    enum ViewStyleAction: Equatable {
        case updateTextViewAppearanceModel(TextViewAppearanceModel)
        case updateTextAppearance(TextAppearanceType, TextAppearance)
        
        case updateLimitCount(Int)
        case updateLimitLine(Int)
    }
    
    struct TextState: Equatable {
        var viewOptionState: ViewOptionState = .init()
        var viewStyleState: ViewStyleState = .init()
    }
    
    enum TextAction: Equatable {
        case viewOption(ViewOptionAction)
        
        case style(ViewStyleAction)
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
    func optionAction(_ action: ViewOptionAction) {
        switch action {
        case .updateColor(let color):
            update(\.viewOptionState.backgroundColor, value: color)
            
        case .updateScrollEnabled(let state):
            update(\.viewOptionState.isScrollEnabled, value: state)
            
        case .updateEditable(let state):
            update(\.viewOptionState.isEditable, value: state)
            
        case .updateSelectable(let state):
            update(\.viewOptionState.isSelectable, value: state)
            
        case .updateSetContentCompressionResistancePriority(let priority, let axis):
            update(\.viewOptionState.contentPriority, value: TextViewContentPriority(priority: priority, axis: axis))
            
        case .updateTextContainerInset(let edgeInsets):
            update(\.viewOptionState.textContainerInset, value: edgeInsets)
        }
    }
    
}

private extension TextViewModel {
    func styleAction(_ action: ViewStyleAction) {
        switch action {
        case .updateTextViewAppearanceModel(let appearance):
            update(\.viewStyleState.appearance, value: appearance)
            
        case .updateTextAppearance(let type, let appearance):
            switch type {
            case .focus:
                update(\.viewStyleState.appearance.focus, value: appearance)
            case .noneFocus:
                update(\.viewStyleState.appearance.noneFocus, value: appearance)
            }
            
        case .updateLimitCount(let count):
            update(\.viewStyleState.limitCount, value: count)
            
        case .updateLimitLine(let line):
            update(\.viewStyleState.limitLine, value: line)
        }
    }
}

private extension TextViewModel {
    func update<V>(_ keyPath: WritableKeyPath<State, V>, value: V) where V: Equatable {
        state[keyPath: keyPath] = value
    }
}
