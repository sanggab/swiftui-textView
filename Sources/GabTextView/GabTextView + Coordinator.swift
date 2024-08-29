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
        let mode: TextViewDelegateMode = parent.viewModel(\.delegateMode)
        
        switch mode {
        case .none:
            break
        case .automatic:
            let focusAppearance: TextAppearance = parent.viewModel(\.styleState.appearance).focus
            textView.font = focusAppearance.font
            textView.textColor = UIColor(focusAppearance.color)
        case .modifier:
            parent.textViewDidBeginEditing?(textView)
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        let mode: TextViewDelegateMode = parent.viewModel(\.delegateMode)
        
        switch mode {
        case .none:
            break
        case .automatic:
            parent.text = textView.text
        case .modifier:
            parent.textViewDidChange?(textView)
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        let mode: TextViewDelegateMode = parent.viewModel(\.delegateMode)
        
        switch mode {
        case .none:
            break
        case .automatic:
            let noneFocusAppearance: TextAppearance = parent.viewModel(\.styleState.appearance).noneFocus
            textView.font = noneFocusAppearance.font
            textView.textColor = UIColor(noneFocusAppearance.color)
            
            let trimMode: TextViewTrimMode = parent.viewModel(\.styleState.trimMode)
            
            switch trimMode {
            case .whitespaces:
                textView.text = textView.text.trimmingCharacters(in: .whitespaces)
                parent.text = textView.text
            case .whitespacesAndNewlines:
                textView.text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
                parent.text = textView.text
            case .blankWithWhitespaces:
                textView.text = textView.text.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "")
                parent.text = textView.text
            case .blankWithWhitespacesAndNewlines:
                textView.text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
                parent.text = textView.text
            case .none:
                break
            }
        case .modifier:
            parent.textViewDidEndEditing?(textView)
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let mode: TextViewDelegateMode = parent.viewModel(\.delegateMode)
                
        switch mode {
        case .none:
            return true
        case .automatic:
            return conditionTextView(textView, shouldChangeTextIn: range, replacementText: text)
        case .modifier:
            return parent.shouldChangeTextIn?(textView, range, text) ?? true
        }
        
    }
    
    // TODO: textContainerInset 대응하기
    private func conditionTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if checkInputBreakMode(textView, replacementText: text) {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let textHeight = newText.boundingRect(with: CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude),
                                                      options: .usesLineFragmentOrigin,
                                                      attributes: [NSAttributedString.Key.font: textView.font ?? UIFont.boldSystemFont(ofSize: 15)],
                                                      context: nil).height
            
            let lines = Int(textHeight / (textView.font?.lineHeight ?? 0))
            
            if lines > parent.viewModel(\.styleState.limitLine) {
                return false
            }
            
            var changedText: String = ""
            
            switch parent.viewModel(\.styleState.trimMode) {
            case .none:
                changedText = newText
            case .whitespaces:
                changedText = newText.trimmingCharacters(in: .whitespaces)
            case .whitespacesAndNewlines:
                changedText = newText.trimmingCharacters(in: .whitespacesAndNewlines)
            case .blankWithWhitespaces:
                changedText = newText.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "")
            case .blankWithWhitespacesAndNewlines:
                changedText = newText.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
            }
            
            if changedText.count > parent.viewModel(\.styleState.limitCount) {
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
            return false
        }
    }
}

// MARK: - automatic 미구현
public extension TextViewCoordinator {
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let mode: TextViewDelegateMode = parent.viewModel(\.delegateMode)
                
        switch mode {
        case .none:
            return true
        case .automatic:
            return true
        case .modifier:
            return parent.shouldInteractWith?(textView, url, characterRange, interaction) ?? true
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let mode: TextViewDelegateMode = parent.viewModel(\.delegateMode)
                
        switch mode {
        case .none:
            return true
        case .automatic:
            return true
        case .modifier:
            return parent.textViewShouldBeginEditing?(textView) ?? true
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let mode: TextViewDelegateMode = parent.viewModel(\.delegateMode)
                
        switch mode {
        case .none:
            break
        case .automatic:
            break
        case .modifier:
            parent.textViewDidChangeSelection?(textView)
        }
        
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        let mode: TextViewDelegateMode = parent.viewModel(\.delegateMode)
                
        switch mode {
        case .none:
            return true
        case .automatic:
            return true
        case .modifier:
            return parent.textViewShouldEndEditing?(textView) ?? true
        }
    }
}

public extension TextViewCoordinator {
    func textView(_ textView: UITextView, editMenuForTextIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
        let mode: TextViewDelegateMode = parent.viewModel(\.delegateMode)
                
        switch mode {
        case .none:
            return nil
        case .automatic:
            return nil
        case .modifier:
            return parent.editMenuForTextIn?(textView, range, suggestedActions)
        }
        
    }
    
    @available(iOS 16.0, *)
    func textView(_ textView: UITextView, willDismissEditMenuWith animator: UIEditMenuInteractionAnimating) {
        let mode: TextViewDelegateMode = parent.viewModel(\.delegateMode)
                
        switch mode {
        case .none:
            break
        case .automatic:
            break
        case .modifier:
            parent.willDismissEditMenuWith?(textView, animator)
        }
        
    }
    
    @available(iOS 16.0, *)
    func textView(_ textView: UITextView, willPresentEditMenuWith animator: UIEditMenuInteractionAnimating) {
        let mode: TextViewDelegateMode = parent.viewModel(\.delegateMode)
                
        switch mode {
        case .none:
            break
        case .automatic:
            break
        case .modifier:
            parent.willPresentEditMenuWith?(textView, animator)
        }
    }
    
    @available(iOS 17.0, *)
    func textView(_ textView: UITextView, primaryActionFor textItem: UITextItem, defaultAction: UIAction) -> UIAction? {
        let mode: TextViewDelegateMode = parent.viewModel(\.delegateMode)
                
        switch mode {
        case .none:
            return nil
        case .automatic:
            return nil
        case .modifier:
            return parent.primaryActionFor?(textView, textItem, defaultAction)
        }
        
    }
    
    @available(iOS 17.0, *)
    func textView(_ textView: UITextView, menuConfigurationFor textItem: UITextItem, defaultMenu: UIMenu) -> UITextItem.MenuConfiguration? {
        let mode: TextViewDelegateMode = parent.viewModel(\.delegateMode)
                
        switch mode {
        case .none:
            return nil
        case .automatic:
            return nil
        case .modifier:
            return parent.menuConfigurationFor?(textView, textItem, defaultMenu)
        }
    }
    
    @available(iOS 17.0, *)
    func textView(_ textView: UITextView, textItemMenuWillEndFor textItem: UITextItem, animator: UIContextMenuInteractionAnimating) {
        let mode: TextViewDelegateMode = parent.viewModel(\.delegateMode)
                
        switch mode {
        case .none:
            break
        case .automatic:
            break
        case .modifier:
            parent.textItemMenuWillEndFor?(textView, textItem, animator)
        }
        
    }
    
    @available(iOS 17.0, *)
    func textView(_ textView: UITextView, textItemMenuWillDisplayFor textItem: UITextItem, animator: UIContextMenuInteractionAnimating) {
        let mode: TextViewDelegateMode = parent.viewModel(\.delegateMode)
                
        switch mode {
        case .none:
            break 
        case .automatic:
            break
        case .modifier:
            parent.textItemMenuWillDisplayFor?(textView, textItem, animator)
        }
    }
}

extension TextViewCoordinator {
    func checkInputBreakMode(_ textView: UITextView, replacementText text: String) -> Bool {
        switch parent.viewModel(\.styleState.inputBreakMode) {
        case .none:
            return true
            
        case .lineBreak:
            
            if text == "\n" {
                return false
            } else {
                return true
            }
            
        case .whiteSpace:
            
            if text == " " {
                return false
            } else {
                return true
            }
            
        case .continuousWhiteSpace:
            
            let lastText = textView.text.last
            
            if lastText == " " && text == " " {
                return false
            } else {
                return true
            }
            
        case .lineWithWhiteSpace:
            
            if text == "\n" || text == " " {
                return false
            } else {
                return true
            }
            
        case .lineWithContinuousWhiteSpace:
            
            let lastText = textView.text.last
            
            if text == "\n" || lastText == " " && text == " " {
                return false
            } else {
                return true
            }
        }
    }
}
