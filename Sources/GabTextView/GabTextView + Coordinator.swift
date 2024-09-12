//
//  GabTextView + Coordinator.swift
//  GabTextView
//
//  Created by Gab on 2024/08/13.
//

import SwiftUI

public final class TextViewCoordinator: NSObject, UITextViewDelegate {
    
    private var parent: TextView
    @ObservedObject var viewModel: TextViewModel
    
    init(parent: TextView, viewModel: TextViewModel) {
        self.parent = parent
        self.viewModel = viewModel
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        let mode: TextViewDelegateMode = viewModel(\.delegateMode)
        
        switch mode {
        case .none:
            break
        case .automatic:
            let focusAppearance: TextAppearance = viewModel(\.styleState.appearance).focus
            textView.font = focusAppearance.font
            textView.textColor = UIColor(focusAppearance.color)
        case .modifier:
            parent.textViewDidBeginEditing?(textView)
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        let mode: TextViewDelegateMode = viewModel(\.delegateMode)
        
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
        let mode: TextViewDelegateMode = viewModel(\.delegateMode)
        
        switch mode {
        case .none:
            break
        case .automatic:
            let noneFocusAppearance: TextAppearance = viewModel(\.styleState.appearance).noneFocus
            textView.font = noneFocusAppearance.font
            textView.textColor = UIColor(noneFocusAppearance.color)
            
            let trimMode: TextViewTrimMode = viewModel(\.styleState.trimMode)
            
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
        let mode: TextViewDelegateMode = viewModel(\.delegateMode)
                
        switch mode {
        case .none:
            return true
        case .automatic:
            return conditionTextView(textView, shouldChangeTextIn: range, replacementText: text)
        case .modifier:
            return parent.shouldChangeTextIn?(textView, range, text) ?? true
        }
        
    }
    
    // TODO: 여기는 inputBreakMode만 적용시켜야 한다. 그 이유는 키보드 입력시의 Text들이 들어오는데 trim을 시킨 Text는 오직 textcount하고 line을 계산할 때 필요하기 때문
    private func conditionTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("상갑 logEvent \(#function) replacementText: \(text)")
        print("상갑 logEvent \(#function) replacementText count: \(text.count)")
        print("상갑 logEvent \(#function) range: \(range)")
        if checkInputBreakMode(textView, replacementText: text) {
//            if limitNewLineAndSpaceCondition(textView, shouldChangeTextIn: range, replacementText: text) {
//                print("상갑 logEvent \(#function) limitNewLineAndSpaceCondition false")
//                return false
//            }
            
            if limitLineCondition(textView, shouldChangeTextIn: range, replacementText: text) {
                print("상갑 logEvent \(#function) limitLineCondition false")
                return false
            }
            
            if limitCountCondition(textView, shouldChangeTextIn: range, replacementText: text) {
                print("상갑 logEvent \(#function) limitCountCondition false")
                return false
            }
            
            return true

            
        } else {
            return false
        }
    }
    
    func newStart(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) {
        switch viewModel(\.styleState.trimMode) {
        case .none:
            print("none")
        case .whitespaces:
            print("whitespaces")
            var newText = text.trimmingCharacters(in: .whitespaces)
        case .whitespacesAndNewlines:
            print("whitespacesAndNewlines")
            var newText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        case .blankWithWhitespaces:
            print("blankWithWhitespaces")
        case .blankWithWhitespacesAndNewlines:
            print("blankWithWhitespacesAndNewlines")
        }
    }
}

// MARK: - automatic 미구현
public extension TextViewCoordinator {
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let mode: TextViewDelegateMode = viewModel(\.delegateMode)
                
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
        let mode: TextViewDelegateMode = viewModel(\.delegateMode)
                
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
        let mode: TextViewDelegateMode = viewModel(\.delegateMode)
                
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
        let mode: TextViewDelegateMode = viewModel(\.delegateMode)
                
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
        let mode: TextViewDelegateMode = viewModel(\.delegateMode)
                
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
        let mode: TextViewDelegateMode = viewModel(\.delegateMode)
                
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
        let mode: TextViewDelegateMode = viewModel(\.delegateMode)
                
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
        let mode: TextViewDelegateMode = viewModel(\.delegateMode)
                
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
        let mode: TextViewDelegateMode = viewModel(\.delegateMode)
                
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
        let mode: TextViewDelegateMode = viewModel(\.delegateMode)
                
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
        let mode: TextViewDelegateMode = viewModel(\.delegateMode)
                
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
        switch viewModel(\.styleState.inputBreakMode) {
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

extension TextViewCoordinator {
    func limitLineCondition(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let textHeight = newText.boundingRect(with: CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude),
                                                  options: .usesLineFragmentOrigin,
                                                  attributes: [NSAttributedString.Key.font: textView.font ?? UIFont.boldSystemFont(ofSize: 15)],
                                                  context: nil).height
        
        let lines = Int(textHeight / (textView.font?.lineHeight ?? 0))
        
        if lines > viewModel(\.styleState.limitLine) {
            return true
        }
        
        return false
    }
    
    func limitCountCondition(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = makeNewText(textView, shouldChangeTextIn: range, replacementText: text)
        
        let changedText = makeTrimText(newText)
        let basicText = makeTrimText(textView.text)
        // TODO: replacementText는 앞으로 입력될 단어
        // TODO: 결국엔 이 단어가 limitCount Modifier에 의해 입력이 막아져야할 경우가 생기는데
        // TODO: count를 막아야 할 경우나 line을 막아야 할 경우는 trim모드로 계산만 도와주기
        if changedText.count > viewModel(\.styleState.limitCount) {
            let prefixCount = max(0, viewModel(\.styleState.limitCount) - basicText.count)
            
            let prefixText = text.prefix(prefixCount)
            
            if !prefixText.isEmpty {
                textView.text.append(contentsOf: prefixText)
                parent.text = textView.text
                textView.selectedRange = NSRange(location: textView.text.count, length: 0)
            }
            
            return true
        }
        
        return false
    }
    
    func limitNewLineAndSpaceCondition(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == " " || text == "\n" {
            let trimText = makeTrimText(textView.text)
            if trimText.count >= viewModel(\.styleState.limitCount) {
                return true
            }
        }
        
        return false
    }
}

extension TextViewCoordinator {
    func makeNewText(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> String {
        return (textView.text as NSString).replacingCharacters(in: range, with: text)
    }
    
    func makeTrimText(_ text: String) -> String {
        var changedText: String = ""
        
        switch viewModel(\.styleState.trimMode) {
        case .none:
            changedText = text
        case .whitespaces:
            changedText = text.trimmingCharacters(in: .whitespaces)
        case .whitespacesAndNewlines:
            changedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        case .blankWithWhitespaces:
            changedText = text.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "")
        case .blankWithWhitespacesAndNewlines:
            changedText = text.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
        }
        
        return changedText
    }
}
