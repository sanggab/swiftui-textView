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
        
        textView.backgroundColor = UIColor(viewModel(\.backgroundColor))
        textView.delegate = context.coordinator
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = viewModel(\.isEditable)
        textView.isSelectable = viewModel(\.isSelectable)
        textView.isScrollEnabled = viewModel(\.isScrollEnabled)
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        
        return textView
    }
    
    public func updateUIView(_ textView: UIViewType, context: Context) {
        print(#function)
    }
    
    public func makeCoordinator() -> TextViewCoordinator {
        TextViewCoordinator(parent: self)
    }
    
}


// TODO: Modifier 채우기
public extension TextView {
    
    func changeBackgroundColor(_ color: Color) -> TextView {
        let view = self
        view.viewModel.action(.updateColor(color))
        return view
    }
    
    func isScrollEnabled(_ state: Bool) -> TextView {
        let view = self
        view.viewModel.action(.updateScrollEnabled(state))
        return view
    }
    
    func isEditable(_ state: Bool) -> TextView {
        let view = self
        view.viewModel.action(.updateEditable(state))
        return view
    }
    
    func isSelectable(_ state: Bool) -> TextView {
        let view = self
        view.viewModel.action(.updateSelectable(state))
        return view
    }
}

public final class TextViewCoordinator: NSObject, UITextViewDelegate {
    
    var parent: TextView
    
    init(parent: TextView) {
        self.parent = parent
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        print("text : \(textView.text)")
        parent.text = textView.text
    }
    
}
