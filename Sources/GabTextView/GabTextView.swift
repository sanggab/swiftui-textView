//
//  GabTextView.swift
//  GabTextView
//
//  Created by Gab on 2024/07/26.
//

import SwiftUI
import SafariServices

public struct TextView: UIViewRepresentable {
    public typealias UIViewType = UITextView
    
    @ObservedObject var viewModel: TextViewModel = TextViewModel()
    
    @Binding public var text: String
    
    var dataDetectorTypesLinkUrl: ((URL) -> Void)?
    
    public init(text: Binding<String>) {
        self._text = text
    }
    
    public func makeUIView(context: Context) -> UIViewType {
        let textView: UITextView = UITextView()
        textView.text = text
        textView.delegate = context.coordinator
//        textView.textContainer.lineFragmentPadding = 0
        bindTextView(textView)
        
        
        return textView
    }
    
    public func updateUIView(_ textView: UIViewType, context: Context) {
//        print(#function)
    }
    
    public func makeCoordinator() -> TextViewCoordinator {
        TextViewCoordinator(parent: self)
    }
}

// MARK: - Bind
private extension TextView {
    func bindTextView(_ textView: UITextView) {
        bindViewState(textView)
        bindScrollViewState(textView)
        bindContentPriorityState(textView)
        bindStyleState(textView)
    }
}

// MARK: - View Bind
private extension TextView {
    func bindViewState(_ textView: UITextView) {
        let viewState = viewModel(\.viewState)
        
        textView.backgroundColor = UIColor(viewState.backgroundColor)
        textView.textAlignment = viewState.textAlignment
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
