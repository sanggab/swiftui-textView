//
//  GabTextView + Helper.swift
//  GabTextView
//
//  Created by Gab on 2024/09/11.
//

import SwiftUI

extension TextView {
    /// Range의 Location이 zero일 경우에만 사용
    func reassembleInputBreak(_ replacementText: String) -> String {
        print("상갑 logEvent \(#function) : \(viewModel(\.styleState.inputBreakMode))")
        switch viewModel(\.styleState.inputBreakMode) {
        case .none:
            return replacementText
        case .lineBreak:
            return checkLineBreak(replacementText: replacementText)
        case .whiteSpace:
            return checkWhiteSpace(replacementText: replacementText)
        case .lineWithWhiteSpace:
            return checkLineWithWhiteSpace(replacementText: replacementText)
        case .continuousWhiteSpace:
            return checkContinuousWhiteSpace(replacementText: replacementText)
        case .lineWithContinuousWhiteSpace:
            return checkLineWithContinuousWhiteSpace(replacementText: replacementText)
        }
    }
    
    func reassembleInputBreak(_ textView: UITextView, replacementText: String) -> String {
        print("상갑 logEvent \(#function) : \(viewModel(\.styleState.inputBreakMode))")
        switch viewModel(\.styleState.inputBreakMode) {
        case .none:
            return replacementText
        case .lineBreak:
            return checkLineBreak(textView, replacementText: replacementText)
        case .whiteSpace:
            return checkWhiteSpace(textView, replacementText: replacementText)
        case .lineWithWhiteSpace:
            return checkLineWithWhiteSpace(textView, replacementText: replacementText)
        case .continuousWhiteSpace:
            return checkContinuousWhiteSpace(textView, replacementText: replacementText)
        case .lineWithContinuousWhiteSpace:
            return checkLineWithContinuousWhiteSpace(textView, replacementText: replacementText)
        }
    }
    
    func reassembleTrimMode(_ replacementText: String) -> String {
        switch viewModel(\.styleState.trimMode) {
        case .none:
            return replacementText
        case .whitespaces:
            return replacementText.trimmingCharacters(in: .whitespaces)
        case .whitespacesAndNewlines:
            return replacementText.trimmingCharacters(in: .whitespacesAndNewlines)
        case .blankWithWhitespaces:
            return replacementText.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
        case .blankWithWhitespacesAndNewlines:
            return replacementText.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
        }
    }
}

extension TextView {
    
    func checkLineBreak(replacementText: String) -> String {
        
        return replacementText
    }
    
    func checkLineBreak(_ textView: UITextView, replacementText: String) -> String {
        var limitIndex: Int?
        
        for i in 0..<replacementText.count {
            let index: String.Index? = replacementText.index(replacementText.startIndex, offsetBy: i, limitedBy: replacementText.endIndex)
            
            var char1: Character?
            
            if let index {
                let limit = replacementText.distance(from: replacementText.startIndex, to: index)
                char1 = replacementText.count > limit ? replacementText[index] : nil
            }
            
            if isCharNextLine(char1) {
                limitIndex = i
                break
            }
        }
        
        if let limitIndex {
            let prefixText = replacementText.prefix(limitIndex)
            print("상갑 logEvent \(#function) prefixText: \(Optional(prefixText))")
            return String(prefixText)
        }
        
        return replacementText
    }
}

extension TextView {
    
    func checkWhiteSpace(replacementText: String) -> String {
        
        return replacementText
    }
    
    func checkWhiteSpace(_ textView: UITextView, replacementText: String) -> String {
        var limitIndex: Int?
        
        for i in 0..<replacementText.count {
            let index: String.Index? = replacementText.index(replacementText.startIndex, offsetBy: i, limitedBy: replacementText.endIndex)
            
            var char1: Character?
            
            if let index {
                let limit = replacementText.distance(from: replacementText.startIndex, to: index)
                char1 = replacementText.count > limit ? replacementText[index] : nil
            }
            
            if isCharWhiteSpace(char1) {
                limitIndex = i
                break
            }
        }
        
        if let limitIndex {
            let prefixText = replacementText.prefix(limitIndex)
            print("상갑 logEvent \(#function) prefixText: \(Optional(prefixText))")
            return String(prefixText)
        }
        
        return replacementText
    }
}

extension TextView {
    
    func checkLineWithWhiteSpace(replacementText: String) -> String {
        
        return replacementText
    }
    
    func checkLineWithWhiteSpace(_ textView: UITextView, replacementText: String) -> String {
        var limitIndex: Int?
        
        for i in 0..<replacementText.count {
            let index: String.Index? = replacementText.index(replacementText.startIndex, offsetBy: i, limitedBy: replacementText.endIndex)
            
            var char1: Character?
            
            if let index {
                let limit = replacementText.distance(from: replacementText.startIndex, to: index)
                char1 = replacementText.count > limit ? replacementText[index] : nil
            }
            
            if isCharWhiteSpace(char1) || isCharNextLine(char1) {
                limitIndex = i
                break
            }
        }
        
        if let limitIndex {
            let prefixText = replacementText.prefix(limitIndex)
            print("상갑 logEvent \(#function) prefixText: \(Optional(prefixText))")
            return String(prefixText)
        }
        
        return replacementText
    }
}

extension TextView {
    
    func checkContinuousWhiteSpace(replacementText: String) -> String {
        var lastKeyWord: Character?
        var limitIndex: Int?
        
        for i in 0..<replacementText.count {
            let charIndex: String.Index? = replacementText.index(replacementText.startIndex, offsetBy: i, limitedBy: replacementText.endIndex)
            
            var char1: Character?
            
            if let charIndex {
                let limit = replacementText.distance(from: replacementText.startIndex, to: charIndex)
                char1 = replacementText.count > limit ? replacementText[charIndex] : nil
            }
            
            print("상갑 logEvent \(#function) char1: \(char1)")
            if isCharsWhiteSpace(lastKeyWord, char1) {
                print("연속공백")
                limitIndex = i
                break
            } else {
                lastKeyWord = char1
            }
        }
        
        if let limitIndex {
            let prefixText = replacementText.prefix(limitIndex)
            print("상갑 logEvent \(#function) prefixText: \(Optional(prefixText))")
            return String(prefixText)
        }
        
        return replacementText
    }
    
    func checkContinuousWhiteSpace(_ textView: UITextView, replacementText: String) -> String {
        let last: Character? = textView.text.last
        var lastKeyWord: Character?
        var limitIndex: Int?
        
        for i in 0..<replacementText.count {
            let index: String.Index? = replacementText.index(replacementText.startIndex, offsetBy: i, limitedBy: replacementText.endIndex)
            
            var char1: Character?
            
            if let index {
                let limit = replacementText.distance(from: replacementText.startIndex, to: index)
                char1 = replacementText.count > limit ? replacementText[index] : nil
            }
            
            if i == .zero && isCharsWhiteSpace(last, char1) {
                print("연속 공백")
                limitIndex = i
                break
            } else if isCharsWhiteSpace(lastKeyWord, char1) {
                print("연속 공백2")
                limitIndex = i
                break
            } else {
                lastKeyWord = char1
            }
        }
        
        if let limitIndex {
            let prefixText = replacementText.prefix(limitIndex)
            print("상갑 logEvent \(#function) prefixText: \(Optional(prefixText))")
            return String(prefixText)
        }
        
        return replacementText
    }
}

extension TextView {
    
    func checkLineWithContinuousWhiteSpace(replacementText: String) -> String {
        var lastKeyWord: Character?
        var limitIndex: Int?
        
        for i in 0..<replacementText.count {
            let index: String.Index? = replacementText.index(replacementText.startIndex, offsetBy: i, limitedBy: replacementText.endIndex)
            
            var char1: Character?
            
            if let index {
                let limit = replacementText.distance(from: replacementText.startIndex, to: index)
                char1 = replacementText.count > limit ? replacementText[index] : nil
            }
            
            if isCharsWhiteSpace(lastKeyWord, char1) {
                print("연속공백")
                limitIndex = i
                break
            } else if isCharNextLine(char1) {
                print("개행")
                limitIndex = i
                break
            } else {
                lastKeyWord = char1
            }
        }
        
        if let limitIndex {
            let prefixText = replacementText.prefix(limitIndex)
            print("상갑 logEvent \(#function) prefixText: \(Optional(prefixText))")
            return String(prefixText)
        }
        
        return replacementText
    }
    
    func checkLineWithContinuousWhiteSpace(_ textView: UITextView, replacementText: String) -> String {
        let last: Character? = textView.text.last
        var lastKeyWord: Character?
        var limitIndex: Int?
        
        for i in 0..<replacementText.count {
            let index: String.Index? = replacementText.index(replacementText.startIndex, offsetBy: i, limitedBy: replacementText.endIndex)
            
            var char1: Character?
            
            if let index {
                let limit = replacementText.distance(from: replacementText.startIndex, to: index)
                char1 = replacementText.count > limit ? replacementText[index] : nil
            }
            
            if i == .zero && isCharsWhiteSpace(last, char1) {
                print("연속 공백")
                limitIndex = i
                break
            } else if isCharsWhiteSpace(lastKeyWord, char1) {
                print("연속 공백2")
                limitIndex = i
                break
            } else if isCharNextLine(char1) {
                print("개행")
                limitIndex = i
                break
            } else {
                lastKeyWord = char1
            }
        }
        
        if let limitIndex {
            let prefixText = replacementText.prefix(limitIndex)
            print("상갑 logEvent \(#function) prefixText: \(Optional(prefixText))")
            return String(prefixText)
        }
        
        return replacementText
    }
}

private extension TextView {
    func isCharWhiteSpace(_ char1: Character?) -> Bool {
        return char1 == " "
    }
    
    func isCharNextLine(_ char: Character?) -> Bool {
        return char == "\n"
    }
    
    func isCharsWhiteSpace(_ char1: Character?, _ char2: Character?) -> Bool {
        return char1 == " " && char1 == char2
    }
}
