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
    
    private func conditionTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if checkInputBreakMode(textView, replacementText: text) {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            
            let textHeight = newText.boundingRect(with: CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude),
                                                      options: .usesLineFragmentOrigin,
                                                      attributes: [NSAttributedString.Key.font: textView.font ?? UIFont.boldSystemFont(ofSize: 15)],
                                                      context: nil).height
            
            let lines = Int(textHeight / (textView.font?.lineHeight ?? 0))
            
            if lines > parent.viewModel(\.styleState.limitLine) {
                
                let limitedText = truncateTextToLimitLines(text: newText, limitLines: parent.viewModel(\.styleState.limitLine), textView: textView)
                
                print("상갑 logEvent limitedText\(#function) : \(limitedText)")
                textView.text = limitedText
                parent.text = textView.text
                
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
        print("상갑 logEvent \(#function)")
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
    
    func truncateTextToLimitLines(text: String, limitLines: Int, textView: UITextView) -> String {
        let lines = text.split(separator: "\n")
        
        var limitedText = ""
        var currentLineCount = 0
        
        for line in lines {
            let lineText = String(line)
            
            // 라인의 줄 수 계산
            let lineHeight = lineText.boundingRect(with: CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude),
                                                   options: .usesLineFragmentOrigin,
                                                   attributes: [NSAttributedString.Key.font: textView.font ?? UIFont.systemFont(ofSize: 15)],
                                                   context: nil).height
            let lineCount = Int(lineHeight / (textView.font?.lineHeight ?? 1))
            
            if currentLineCount + lineCount <= limitLines {
                limitedText.append(contentsOf: lineText)
                limitedText.append("\n")
                currentLineCount += lineCount
            } else {
                // 남은 줄 수만큼 잘라내기
                let remainingLines = limitLines - currentLineCount
                let truncatedLine = truncateLineToLimit(line: lineText, remainingLines: remainingLines, textView: textView)
                limitedText.append(contentsOf: truncatedLine)
                break
            }
        }
        
        if limitedText.count > parent.viewModel(\.styleState.limitCount) {
            let prefixCount = parent.viewModel(\.styleState.limitCount) - textView.text.count
            
            guard prefixCount > 0 else {
                return limitedText
            }
            
            limitedText = String(text.prefix(prefixCount))
        }
        
        print("상갑 logEvent limitedText\(#function) : \(limitedText)")

        
        return limitedText
    }

    // 줄 수에 맞게 라인을 잘라내는 함수
    func truncateLineToLimit(line: String, remainingLines: Int, textView: UITextView) -> String {
        var truncatedLine = ""
        var currentText = ""
        
        for character in line {
            currentText.append(character)
            
            let lineHeight = currentText.boundingRect(with: CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude),
                                                      options: .usesLineFragmentOrigin,
                                                      attributes: [NSAttributedString.Key.font: textView.font ?? UIFont.systemFont(ofSize: 15)],
                                                      context: nil).height
            let lineCount = Int(lineHeight / (textView.font?.lineHeight ?? 1))
            
            if lineCount > remainingLines {
                break
            }
            
            truncatedLine = currentText
        }
        
        return truncatedLine
    }
}
