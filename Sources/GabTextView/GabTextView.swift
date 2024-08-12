//
//  GabTextView.swift
//  GabTextView
//
//  Created by Gab on 2024/07/26.
//

import SwiftUI

public struct TextView: UIViewRepresentable {
    public typealias UIViewType = UITextView
    
    @ObservedObject var viewModel: TextViewModel = TextViewModel()
    
    @Binding public var text: String
    
    public init(text: Binding<String>) {
        self._text = text
    }
    
    public func makeUIView(context: Context) -> UIViewType {
        let textView: UITextView = UITextView()
        
        let noneFocusModel: TextAppearance = viewModel(\.viewStyleState.appearance).noneFocus
        textView.font = noneFocusModel.font
        textView.textColor = UIColor(noneFocusModel.color)
        textView.text = text
        
        textView.backgroundColor = UIColor(viewModel(\.viewOptionState.backgroundColor))
        textView.delegate = context.coordinator
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = viewModel(\.viewOptionState.isEditable)
        textView.isSelectable = viewModel(\.viewOptionState.isSelectable)
        textView.isScrollEnabled = viewModel(\.viewOptionState.isScrollEnabled)
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.setContentCompressionResistancePriority(viewModel(\.viewOptionState.contentPriority).priority, for: viewModel(\.viewOptionState.contentPriority).axis)
        
        
        if text.count > viewModel(\.viewStyleState.limitCount) {
            let prefixText = textView.text.prefix(viewModel(\.viewStyleState.limitCount))
            textView.text = String(prefixText)
            text = String(prefixText)
        }
        
        return textView
    }
    
    public func updateUIView(_ textView: UIViewType, context: Context) {
//        print(#function)
    }
    
    public func makeCoordinator() -> TextViewCoordinator {
        TextViewCoordinator(parent: self)
    }
}

public final class TextViewCoordinator: NSObject, UITextViewDelegate {
    
    private var parent: TextView
    
    fileprivate init(parent: TextView) {
        self.parent = parent
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        let focusAppearance: TextAppearance = parent.viewModel(\.viewStyleState.appearance).focus
        textView.font = focusAppearance.font
        textView.textColor = UIColor(focusAppearance.color)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        parent.text = textView.text
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        let noneFocusAppearance: TextAppearance = parent.viewModel(\.viewStyleState.appearance).noneFocus
        textView.font = noneFocusAppearance.font
        textView.textColor = UIColor(noneFocusAppearance.color)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        let textHeight = newText.boundingRect(with: CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude),
                                                  options: .usesLineFragmentOrigin,
                                                  attributes: [NSAttributedString.Key.font: textView.font ?? UIFont.boldSystemFont(ofSize: 15)],
                                                  context: nil).height
        
        let lines = Int(textHeight / (textView.font?.lineHeight ?? 0))
        
        if lines > parent.viewModel(\.viewStyleState.limitLine) {
            return false
        }
        
        if newText.count > parent.viewModel(\.viewStyleState.limitCount) {
            let prefixCount = parent.viewModel(\.viewStyleState.limitCount) - textView.text.count
            
            guard prefixCount > 0 else {
                return false
            }
            
            let prefixText = text.prefix(prefixCount)
            textView.text.append(contentsOf: prefixText)
            parent.text = textView.text
            
            textView.selectedRange = NSRange(location: parent.viewModel(\.viewStyleState.limitCount), length: 0)
        }
        
        return true
    }
}
