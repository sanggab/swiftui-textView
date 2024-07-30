//
//  GabTextView.swift
//  GabTextView
//
//  Created by Gab on 2024/07/26.
//

import SwiftUI

public struct TextView: UIViewRepresentable {
    public typealias UIViewType = UITextView
    
    
    @Binding public var text: String
    
    public init(text: Binding<String>) {
        self._text = text
    }
    
    public func makeUIView(context: Context) -> UIViewType {
        let textView: UITextView = UITextView()
        textView.backgroundColor = .gray
        
//        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = true
        textView.isSelectable = true
//        textView.isScrollEnabled = isScrollEnabled
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        
        return textView
    }
    
    public func updateUIView(_ textView: UIViewType, context: Context) {
        print(#function)
    }
    
    public func makeCoordinator() -> TextViewCoordinator {
        TextViewCoordinator()
    }
    
}


// TODO: Modifier 채우기
public extension TextView {
    
    func changeBackgroundColor(_ color: Color) -> TextView {
        let view = self
        return view
    }
}

public final class TextViewCoordinator: NSObject, UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        
    }
    
}
