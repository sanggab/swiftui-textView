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
    
    @Binding var text: String
    
    var configuration: ((UITextView) -> Void)?
    
    var textViewShouldBeginEditing: ((UITextView) -> Bool)?
    var textViewDidBeginEditing: ((UITextView) -> Void)?
    
    var textViewDidChange: ((UITextView) -> Void)?
    var textViewDidChangeSelection: ((UITextView) -> Void)?
    
    var textViewShouldEndEditing: ((UITextView) -> Bool)?
    var textViewDidEndEditing: ((UITextView) -> Void)?
    
    var shouldChangeTextIn: ((UITextView, NSRange, String) -> Bool)?
    var shouldInteractWith: ((UITextView, URL, NSRange, UITextItemInteraction) -> Bool)?
    var editMenuForTextIn: ((UITextView, NSRange, [UIMenuElement]) -> UIMenu?)?
    
    var _willDismissEditMenuWith: Any? = nil
    var _willPresentEditMenuWith: Any? = nil
    var _primaryActionFor: Any? = nil
    var _menuConfigurationFor: Any? = nil
    var _textItemMenuWillEndFor: Any? = nil
    var _textItemMenuWillDisplayFor: Any? = nil
    
    var calTextViewHeight: ((CGFloat) -> Void)?
    
    
    public init(text: Binding<String>) {
        self._text = text
    }
    
    public func makeUIView(context: Context) -> UIViewType {
        let textView: UITextView = UITextView()
        
        if let configuration {
            configuration(textView)
        } else {
            textView.text = text
            bindTextView(textView)
        }
        
        if viewModel(\.delegateMode) != .none {
            textView.delegate = context.coordinator
        }
        
        return textView
    }
    
    public func updateUIView(_ textView: UIViewType, context: Context) {
        print(#function)
        updateHeight(textView)
    }
    
    public func makeCoordinator() -> TextViewCoordinator {
        TextViewCoordinator(parent: self)
    }
    
    private func updateHeight(_ textView: UITextView) {
        DispatchQueue.main.async {
//            print("상갑 logEvent \(#function) textView.frame: \(textView.frame)")
//            print("상갑 logEvent \(#function) textView.bounds: \(textView.bounds)")
//            print("상갑 logEvent \(#function) textView.contentSize: \(textView.contentSize)")
//            print("상갑 logEvent \(#function) textView.visibleSize: \(textView.visibleSize)")
//            print("상갑 logEvent \(#function) textView.intrinsicContentSize: \(textView.intrinsicContentSize)")
            
            if viewModel(\.sizeMode) == .dynamic {
//                let textViewRect = textView.text.boundingRect(with: CGSize(width: textView.bounds.width,
//                                                                           height: textView.contentSize.height),
//                                                              options: .usesLineFragmentOrigin,
//                                                              attributes: [NSAttributedString.Key.font: textView.font ?? viewModel(\.styleState.appearance.focus.font)],
//                                                              context: nil)
//                
//                print("상갑 logEvent \(#function) textViewRect: \(textViewRect)")
//                print("상갑 logEvent \(#function) textView.font?.lineHeight: \(textView.font?.lineHeight)")
//
//                let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width,
//                                                        height: .infinity))
//
//                print("상갑 logEvent \(#function) size: \(size)")
//                let lines = Int(textViewRect.height / (textView.font?.lineHeight ?? 0))
//                print("상갑 logEvent \(#function) lines: \(lines)")

                calTextViewHeight?(textView.contentSize.height)
            }
        }
    }
}

// MARK: - Bind
private extension TextView {
    func bindTextView(_ textView: UITextView) {
        bindViewState(textView)
        bindScrollViewState(textView)
        bindContentPriorityState(textView)
        bindStyleState(textView)
        bindTextContainerState(textView)
    }
}

// MARK: - View Bind
private extension TextView {
    func bindViewState(_ textView: UITextView) {
        let viewState = viewModel(\.viewState)
        
        textView.backgroundColor = UIColor(viewModel(\.viewState).backgroundColor)
        textView.textAlignment = viewModel(\.viewState).textAlignment
        textView.isEditable = viewState.isEditable
        textView.isSelectable = viewState.isSelectable
        
        if let dataDetectorTypes = viewState.dataDetectorTypes {
            textView.dataDetectorTypes = dataDetectorTypes
        }
        
        textView.textContainerInset = viewState.textContainerInset
        textView.usesStandardTextScaling = viewState.usesStandardTextScaling
        
        if #available(iOS 16.0, *) {
            textView.isFindInteractionEnabled = viewState.isFindInteractionEnabled
        }
    }
}

// MARK: - Scroll Bind
private extension TextView {
    func bindScrollViewState(_ textView: UITextView) {
        let scrollViewState = viewModel(\.scrollViewState)
        
        if scrollViewState.contentOffset != .zero {
            textView.contentOffset = scrollViewState.contentOffset
        }
        
        if scrollViewState.contentSize != .zero {
            textView.contentSize = scrollViewState.contentSize
        }
        
        if scrollViewState.contentInset != .zero {
            textView.contentInset = scrollViewState.contentInset
        }
        
        textView.isScrollEnabled = scrollViewState.isScrollEnabled
        textView.contentInsetAdjustmentBehavior = scrollViewState.contentInsetAdjustmentBehavior
        textView.automaticallyAdjustsScrollIndicatorInsets = scrollViewState.automaticallyAdjustsScrollIndicatorInsets
        textView.isDirectionalLockEnabled = scrollViewState.isDirectionalLockEnabled
        textView.bounces = scrollViewState.bounces
        textView.alwaysBounceVertical = scrollViewState.alwaysBounceVertical
        textView.alwaysBounceHorizontal = scrollViewState.alwaysBounceHorizontal
        textView.isPagingEnabled = scrollViewState.isPagingEnabled
        textView.showsVerticalScrollIndicator = scrollViewState.showsVerticalScrollIndicator
        textView.showsHorizontalScrollIndicator = scrollViewState.showsHorizontalScrollIndicator
        textView.indicatorStyle = scrollViewState.indicatorStyle
        textView.verticalScrollIndicatorInsets = scrollViewState.verticalScrollIndicatorInsets
        textView.horizontalScrollIndicatorInsets = scrollViewState.horizontalScrollIndicatorInsets
        textView.decelerationRate = scrollViewState.decelerationRate
        
        if let indexDisplayMode = scrollViewState.indexDisplayMode {
            textView.indexDisplayMode = indexDisplayMode
        }
        
        textView.delaysContentTouches = scrollViewState.delaysContentTouches
        textView.canCancelContentTouches = scrollViewState.canCancelContentTouches
        textView.minimumZoomScale = scrollViewState.minimumZoomScale
        textView.maximumZoomScale = scrollViewState.maximumZoomScale
        textView.zoomScale = scrollViewState.zoomScale
        textView.bouncesZoom = scrollViewState.bouncesZoom
        textView.scrollsToTop = scrollViewState.scrollsToTop
        textView.keyboardDismissMode = scrollViewState.keyboardDismissMode
        
        if let refreshControl = scrollViewState.refreshControl {
            textView.refreshControl = refreshControl
        }
        
        if #available(iOS 17.0, *) {
            textView.allowsKeyboardScrolling = scrollViewState.allowsKeyboardScrolling
        }
    }
}

// MARK: - ContentPriority Bind
private extension TextView {
    func bindContentPriorityState(_ textView: UITextView) {
        let contentPriorityState = viewModel(\.contentPriorityState).contentPriority
        
        if let hugging = contentPriorityState.hugging {
            textView.setContentHuggingPriority(hugging.priority, for: hugging.axis)
        }
        
        if let compressionResistance = contentPriorityState.compressionResistance {
            textView.setContentCompressionResistancePriority(compressionResistance.priority, for: compressionResistance.axis)
        }
    }
}

// MARK: - Style Bind
private extension TextView {
    func bindStyleState(_ textView: UITextView) {
        let styleState = viewModel(\.styleState)
        
        let noneFocusModel = styleState.appearance.noneFocus
        textView.font = noneFocusModel.font
        textView.textColor = UIColor(noneFocusModel.color)
        
        if text.count > styleState.limitCount {
            let prefixText = textView.text.prefix(styleState.limitCount)
            textView.text = String(prefixText)
            text = String(prefixText)
        }
    }
}

// MARK: - TextContainer Bind
private extension TextView {
    func bindTextContainerState(_ textView: UITextView) {
        let textContainerState = viewModel(\.textContainerState)
        
        textView.textContainer.lineFragmentPadding = textContainerState.lineFragmentPadding
        textView.textContainer.lineBreakMode = textContainerState.lineBreakMode
        textView.textContainer.maximumNumberOfLines = textContainerState.maximumNumberOfLines
        textView.textContainer.widthTracksTextView = textContainerState.widthTracksTextView
        textView.textContainer.heightTracksTextView = textContainerState.heightTracksTextView
    }
}
