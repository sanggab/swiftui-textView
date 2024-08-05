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
        
        let noneFocusModel: TextStyle = viewModel(\.inputModel).noneFocus
        textView.font = noneFocusModel.font
        textView.textColor = UIColor(noneFocusModel.color)
        textView.text = text
        
        textView.backgroundColor = UIColor(viewModel(\.backgroundColor))
        textView.delegate = context.coordinator
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = viewModel(\.isEditable)
        textView.isSelectable = viewModel(\.isSelectable)
        textView.isScrollEnabled = viewModel(\.isScrollEnabled)
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        if text.count > viewModel(\.limitCount) {
            let prefixText = textView.text.prefix(viewModel(\.limitCount))
            textView.text = String(prefixText)
            text = String(prefixText)
        }
        
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
        let view: TextView = self
        view.viewModel.action(.viewOption(.updateColor(color)))
        return view
    }
    
    func isScrollEnabled(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.viewOption(.updateScrollEnabled(state)))
        return view
    }
    
    func isEditable(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.viewOption(.updateEditable(state)))
        return view
    }
    
    func isSelectable(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.viewOption(.updateSelectable(state)))
        return view
    }
    
    func setInputModel(model: TextViewInputModel) -> TextView {
        let view = self
        view.viewModel.action(.style(.updateInputModel(model)))
        return view
    }
    
    @ViewBuilder
    func overlayPlaceHolder<V>(_ alignment: Alignment = .center, @ViewBuilder content: @escaping () -> V) -> some View where V: View {
        if #available(iOS 15.0, *) {
            self.overlay(alignment: alignment) {
                makePlaceHolderView(content: content)
            }
        } else {
            self.overlay(makePlaceHolderView(content: content), alignment: alignment)
        }
    }
    
    func limitCount(_ count: Int) -> TextView {
        let view = self
        view.viewModel.action(.style(.updateLimitCount(count)))
        return view
    }
    
    func limitLine(_ line: Int) -> TextView {
        let view = self
        view.viewModel.action(.style(.updateLimitLine(line)))
        return view
    }
    
    func limitCountAndLine(_ count: Int, _ line: Int) -> TextView {
        let view = self
        view.viewModel.action(.style(.updateLimitCount(count)))
        view.viewModel.action(.style(.updateLimitLine(line)))
        return view
    }
}

// MARK: - Helper
private extension TextView {
    
    @ViewBuilder
    func makePlaceHolderView<V>(@ViewBuilder content: @escaping () -> V) -> some View where V: View {
        if self.text.count <= 0 {
            content()
                .allowsHitTesting(false)
        } else {
            EmptyView()
        }
    }
    
}

public final class TextViewCoordinator: NSObject, UITextViewDelegate {
    
    private var parent: TextView
    
    fileprivate init(parent: TextView) {
        self.parent = parent
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        let focusModel: TextStyle = parent.viewModel(\.inputModel).focus
        textView.font = focusModel.font
        textView.textColor = UIColor(focusModel.color)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        parent.text = textView.text
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        let noneFocusModel: TextStyle = parent.viewModel(\.inputModel).noneFocus
        textView.font = noneFocusModel.font
        textView.textColor = UIColor(noneFocusModel.color)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        let textHeight = newText.boundingRect(with: CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude),
                                                  options: .usesLineFragmentOrigin,
                                                  attributes: [NSAttributedString.Key.font: textView.font ?? UIFont.systemFont(ofSize: 15)],
                                                  context: nil).height
        
        let lines = Int(textHeight / (textView.font?.lineHeight ?? 0))
        
        if lines > parent.viewModel(\.limitLine) {
            return false
        }
        
        if newText.count > parent.viewModel(\.limitCount) {
            let prefixCount = parent.viewModel(\.limitCount) - textView.text.count
            
            guard prefixCount > 0 else {
                return false
            }
            
            let prefixText = text.prefix(prefixCount)
            textView.text.append(contentsOf: prefixText)
            parent.text = textView.text
            
            textView.selectedRange = NSRange(location: parent.viewModel(\.limitCount), length: 0)
        }
        
        return true
    }
}
