//
//  GabTextView + Coordinator.swift
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
        let focusAppearance: TextAppearance = parent.viewModel(\.styleState.appearance).focus
        textView.font = focusAppearance.font
        textView.textColor = UIColor(focusAppearance.color)
//        if parent.viewModel(\.isConfigurationMode) {
//            print("설정 설정!")
//            parent.textViewDidBeginEditing?(textView)
//        } else {
//            let focusAppearance: TextAppearance = parent.viewModel(\.styleState.appearance).focus
//            textView.font = focusAppearance.font
//            textView.textColor = UIColor(focusAppearance.color)
//        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        parent.text = textView.text
//        if parent.viewModel(\.isConfigurationMode) {
//            parent.textViewDidChange?(textView)
//        } else {
//            parent.text = textView.text
//        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        parent.textViewDidEndEditing?(textView)
//        if parent.viewModel(\.isConfigurationMode) {
//            parent.textViewDidEndEditing?(textView)
//        } else {
//            let noneFocusAppearance: TextAppearance = parent.viewModel(\.styleState.appearance).noneFocus
//            textView.font = noneFocusAppearance.font
//            textView.textColor = UIColor(noneFocusAppearance.color)
//        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
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
//        if !parent.viewModel(\.isConfigurationMode) {
//            
//        } else {
//            return true
//        }
    }
    
    public func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if let closure = parent.dataDetectorTypesLinkUrl {
            closure(url)
        }
            
         return false
    }
}

public extension TextViewCoordinator {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if let closure = parent.textViewDidChangeSelection {
            closure(textView)
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if let closure = parent.textViewShouldEndEditing {
            return closure(textView)
        } else {
            return true
        }
    }
}

public extension TextViewCoordinator {
    func textView(_ textView: UITextView, editMenuForTextIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
        return nil
    }
    
    @available(iOS 16.0, *)
    func textView(_ textView: UITextView, willDismissEditMenuWith animator: UIEditMenuInteractionAnimating) {
        
    }
    
    @available(iOS 16.0, *)
    func textView(_ textView: UITextView, willPresentEditMenuWith animator: UIEditMenuInteractionAnimating) {
        
    }
    
    @available(iOS 17.0, *)
    func textView(_ textView: UITextView, primaryActionFor textItem: UITextItem, defaultAction: UIAction) -> UIAction? {
        return nil
    }
    
    @available(iOS 17.0, *)
    func textView(_ textView: UITextView, menuConfigurationFor textItem: UITextItem, defaultMenu: UIMenu) -> UITextItem.MenuConfiguration? {
        return nil
    }
    
    @available(iOS 17.0, *)
    func textView(_ textView: UITextView, textItemMenuWillEndFor textItem: UITextItem, animator: UIContextMenuInteractionAnimating) {
        
    }
    
    @available(iOS 17.0, *)
    func textView(_ textView: UITextView, textItemMenuWillDisplayFor textItem: UITextItem, animator: UIContextMenuInteractionAnimating) {
        
    }
}

public struct TextViewTypealias {
    
    public typealias EditMenuForTextIn = (textView: UITextView, range: NSRange, suggestedActions: [UIMenuElement])
    
    @available(iOS 16.0, *)
    public typealias WillDismissEditMenuWith = (textView: UITextView, animator: UIEditMenuInteractionAnimating)
    
    @available(iOS 16.0, *)
    public typealias WillPresentEditMenuWith = (textView: UITextView, animator: UIEditMenuInteractionAnimating)
    
    @available(iOS 17.0, *)
    public typealias PrimaryActionFor = (textView: UITextView, textItem: UITextItem, defaultAction: UIAction)
    
    @available(iOS 17.0, *)
    public typealias MenuConfigurationFor = (textView: UITextView, textItem: UITextItem, defaultMenu: UIMenu)
    
    @available(iOS 17.0, *)
    public typealias TextItemMenuWillEndFor = (textView: UITextView, textItem: UITextItem, animator: UIContextMenuInteractionAnimating)
    
    @available(iOS 17.0, *)
    public typealias TextItemMenuWillDisplayFor = (textView: UITextView, textItem: UITextItem, animator: UIContextMenuInteractionAnimating)
}
