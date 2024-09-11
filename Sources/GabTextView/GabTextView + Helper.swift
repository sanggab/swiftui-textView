//
//  GabTextView + Helper.swift
//  GabTextView
//
//  Created by Gab on 2024/09/11.
//

import SwiftUI

extension TextView {
    
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
