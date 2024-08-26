//
//  GabTextView + DelegateModifier.swift
//  GabTextView
//
//  Created by Gab on 2024/08/26.
//

import SwiftUI

public extension TextView {
    
    func textViewShouldBeginEditing(_ textViewShouldBeginEditing: @escaping ((UITextView) -> Bool)) -> TextView {
        var view: TextView = self
        view.textViewShouldBeginEditing = textViewShouldBeginEditing
        return view
    }
    
    func textViewDidBeginEditing(_ textViewDidBeginEditing: @escaping ((UITextView) -> Void)) -> TextView {
        var view: TextView = self
        view.textViewDidBeginEditing = textViewDidBeginEditing
        return view
    }
    
    func textViewDidChange(_ textViewDidBeginEditing: @escaping ((UITextView) -> Void)) -> TextView {
        var view: TextView = self
        view.textViewDidChange = textViewDidChange
        return view
    }
    
    func textViewDidChangeSelection(_ textViewDidChangeSelection: @escaping ((UITextView) -> Void)) -> TextView {
        var view: TextView = self
        view.textViewDidChangeSelection = textViewDidChangeSelection
        return view
    }
    
    func textViewShouldEndEditing(_ textViewShouldEndEditing: @escaping ((UITextView) -> Bool)) -> TextView {
        var view: TextView = self
        view.textViewShouldEndEditing = textViewShouldEndEditing
        return view
    }
    
    func textViewDidEndEditing(_ textViewDidBeginEditing: @escaping ((UITextView) -> Void)) -> TextView {
        var view: TextView = self
        view.textViewDidEndEditing = textViewDidEndEditing
        return view
    }
}

public extension TextView {
    
//    @available(iOS 16.0, *)
//    func willDismissEditMenuWith(_ willDismissEditMenuWith: @escaping (() -> Void)) -> TextView {
//        var view: TextView = self
//        
//        return view
//    }
    
    @available(iOS 16.0, *)
    func textViewAvailableTest(_ closure: @escaping ((UITextView) -> Void)) -> TextView {
        var view: TextView = self
        
        return view
    }
}

@available(iOS 16.0, *)
public struct HOHOHO {
    static let shared = HOHOHO()
    var test: ((UITextView) -> Void)?
}
