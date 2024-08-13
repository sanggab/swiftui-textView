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
    
    
    // ------------------------------------------------------------------------------------ //
    struct ViewOptionState: Equatable {
        var backgroundColor: Color = .white
        var textAlignment: NSTextAlignment = .natural
        var isEditable: Bool = true
        var isSelectable: Bool = true
        var dataDetectorTypes: UIDataDetectorTypes?
        var textContainerInset: UIEdgeInsets = UIEdgeInsets(top: 8,
                                                            left: 0,
                                                            bottom: 8,
                                                            right: 0)
        var usesStandardTextScaling: Bool = false
        var isFindInteractionEnabled: Bool = false
    }
    
    enum ViewOptionAction: Equatable {
        case updateColor(Color)
        case updateTextAlignment(NSTextAlignment)
        case updateIsEditable(Bool)
        case updateIsSelectable(Bool)
        case updateDataDetectorTypes(UIDataDetectorTypes)
        case updateTextContainerInset(UIEdgeInsets)
        case updateUsesStandardTextScaling(Bool)
        case updateIsFindInteractionEnabled(Bool)
    }
    // ------------------------------------------------------------------------------------ //
    
    
    
    // ------------------------------------------------------------------------------------ //
    struct ViewScrollOptionState: Equatable {
        var isScrollEnabled: Bool = true
    }
    
    enum ViewScrollOptionAction: Equatable {
        case updateIsScrollEnabled(Bool)
    }
    
    // ------------------------------------------------------------------------------------ //
    
    
    
    // ------------------------------------------------------------------------------------ //
    struct ViewContentPriorityState: Equatable {
        var contentPriority: TextViewContentPriority = .init()
    }
    
    enum ViewContentPriorityAction: Equatable {
        case updateContentHuggingPriority(NSLayoutConstraint.Axis)
        case updateSetContentHuggingPriority(ContentPriorityModel)
        case updateContentCompressionResistancePriority(NSLayoutConstraint.Axis)
        case updateSetContentCompressionResistancePriority(ContentPriorityModel)
    }
    // ------------------------------------------------------------------------------------ //
    
    
    
    // ------------------------------------------------------------------------------------ //
    struct ViewStyleState: Equatable {
        var appearance: TextViewAppearanceModel = .default
        var limitCount: Int = 999999
        var limitLine: Int = 999999
    }
    
    enum ViewStyleAction: Equatable {
        case updateTextViewAppearanceModel(TextViewAppearanceModel)
        case updateTextAppearance(TextAppearanceType, TextAppearance)
        
        case updateLimitCount(Int)
        case updateLimitLine(Int)
    }
    // ------------------------------------------------------------------------------------ //
    
    
    
    // ------------------------------------------------------------------------------------ //
    struct TextState: Equatable {
        var viewOption: ViewOptionState = .init()
        var viewStyle: ViewStyleState = .init()
        var viewScrollOption: ViewScrollOptionState = .init()
        var viewContentPriorityState: ViewContentPriorityState = .init()
    }
    
    enum TextAction: Equatable {
        case viewOption(ViewOptionAction)
        case scrollOption(ViewScrollOptionAction)
        case contentPriority(ViewContentPriorityAction)
        case style(ViewStyleAction)
    }
    // ------------------------------------------------------------------------------------ //
    
    @Published private var state: TextState = .init()
    
    func callAsFunction<V>(_ keyPath: KeyPath<TextState, V>) -> V where V : Equatable {
        return state[keyPath: keyPath]
    }
    
    func action(_ action: TextAction) {
        switch action {
        case .viewOption(let action):
            viewOptionAction(action)
        case .scrollOption(let action):
            scrollAction(action)
        case .contentPriority(let action):
            contentPriorityAction(action)
        case .style(let action):
            styleAction(action)
        }
    }
}

private extension TextViewModel {
    func viewOptionAction(_ action: ViewOptionAction) {
        switch action {
        case .updateColor(let color):
            update(\.viewOption.backgroundColor, value: color)
            
        case .updateTextAlignment(let alignment):
            update(\.viewOption.textAlignment, value: alignment)
            
        case .updateIsEditable(let state):
            update(\.viewOption.isEditable, value: state)
            
        case .updateIsSelectable(let state):
            update(\.viewOption.isEditable, value: state)
            
        case .updateDataDetectorTypes(let dataDetectorTypes):
            update(\.viewOption.dataDetectorTypes, value: dataDetectorTypes)
            
        case .updateTextContainerInset(let edgeInsets):
            update(\.viewOption.textContainerInset, value: edgeInsets)
            
        case .updateUsesStandardTextScaling(let state):
            update(\.viewOption.usesStandardTextScaling, value: state)
            
        case .updateIsFindInteractionEnabled(let edgeInsets):
            update(\.viewOption.isFindInteractionEnabled, value: edgeInsets)
        }
    }
    
}

private extension TextViewModel {
    func scrollAction(_ action: ViewScrollOptionAction) {
        switch action {
        case .updateIsScrollEnabled(let state):
            update(\.viewScrollOption.isScrollEnabled, value: state)
        }
    }
}

private extension TextViewModel {
    func contentPriorityAction(_ action: ViewContentPriorityAction) {
        switch action {
        case .updateContentHuggingPriority(let axis):
            update(\.viewContentPriorityState.contentPriority.hugging, value: ContentPriorityModel(axis: axis))
            
        case .updateSetContentHuggingPriority(let model):
            update(\.viewContentPriorityState.contentPriority.setHugging, value: model)
            
        case .updateContentCompressionResistancePriority(let axis):
            update(\.viewContentPriorityState.contentPriority.compressionResistance, value: ContentPriorityModel(axis: axis))
            
        case .updateSetContentCompressionResistancePriority(let model):
            update(\.viewContentPriorityState.contentPriority.setCompressionResistance, value: model)
        }
    }
}

private extension TextViewModel {
    func styleAction(_ action: ViewStyleAction) {
        switch action {
        case .updateTextViewAppearanceModel(let appearance):
            update(\.viewStyle.appearance, value: appearance)
            
        case .updateTextAppearance(let type, let appearance):
            switch type {
            case .focus:
                update(\.viewStyle.appearance.focus, value: appearance)
            case .noneFocus:
                update(\.viewStyle.appearance.noneFocus, value: appearance)
            }
            
        case .updateLimitCount(let count):
            update(\.viewStyle.limitCount, value: count)
            
        case .updateLimitLine(let line):
            update(\.viewStyle.limitLine, value: line)
        }
    }
}

private extension TextViewModel {
    func update<V>(_ keyPath: WritableKeyPath<State, V>, value: V) where V: Equatable {
        state[keyPath: keyPath] = value
    }
}
