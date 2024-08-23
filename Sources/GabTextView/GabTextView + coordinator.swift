//
//  GabTextView + coordinator.swift
//  GabTextView
//
//  Created by Gab on 2024/08/13.
//

import SwiftUI

public final class TextViewCoordinator: NSObject, UITextViewDelegate {
    
    private var parent: TextView
    
    init(parent: TextView) {
        self.parent = parent
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
//        let focusAppearance: TextAppearance = parent.viewModel(\.styleState.appearance).focus
//        textView.font = focusAppearance.font
//        textView.textColor = UIColor(focusAppearance.color)
        if parent.viewModel(\.isConfigurationMode) {
            print("설정 설정!")
            parent.textViewDidBeginEditing?(textView)
        } else {
            let focusAppearance: TextAppearance = parent.viewModel(\.styleState.appearance).focus
            textView.font = focusAppearance.font
            textView.textColor = UIColor(focusAppearance.color)
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if parent.viewModel(\.isConfigurationMode) {
            parent.textViewDidChange?(textView)
        } else {
            parent.text = textView.text
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if parent.viewModel(\.isConfigurationMode) {
            parent.textViewDidEndEditing?(textView)
        } else {
            let noneFocusAppearance: TextAppearance = parent.viewModel(\.styleState.appearance).noneFocus
            textView.font = noneFocusAppearance.font
            textView.textColor = UIColor(noneFocusAppearance.color)
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if !parent.viewModel(\.isConfigurationMode) {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            
            let textHeight = newText.boundingRect(with: CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude),
                                                      options: .usesLineFragmentOrigin,
                                                      attributes: [NSAttributedString.Key.font: textView.font ?? UIFont.boldSystemFont(ofSize: 15)],
                                                      context: nil).height
            
            let lines = Int(textHeight / (textView.font?.lineHeight ?? 0))
            
            if lines > parent.viewModel(\.styleState.limitLine) {
                return false
            }
            
            if newText.count > parent.viewModel(\.styleState.limitCount) {
                let prefixCount = parent.viewModel(\.styleState.limitCount) - textView.text.count
                
                guard prefixCount > 0 else {
                    return false
                }
                
                let prefixText = text.prefix(prefixCount)
                textView.text.append(contentsOf: prefixText)
                parent.text = textView.text
                
                textView.selectedRange = NSRange(location: parent.viewModel(\.styleState.limitCount), length: 0)
            }
            
            return true
        } else {
            return true
        }
    }
    
    public func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if let closure = parent.dataDetectorTypesLinkUrl {
            closure(url)
        }
            
         return false
    }
}
