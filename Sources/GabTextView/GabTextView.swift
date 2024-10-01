//
//  GabTextView.swift
//  GabTextView
//
//  Created by Gab on 2024/07/26.
//

import SwiftUI

public struct TextView: UIViewRepresentable {
    public typealias UIViewType = UITextView
    public typealias CheckTypeAlias = (range: NSRange, replacementText: String)
    
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
    
    var receiveTextViewHeight: ((CGFloat) -> Void)?
    var receiveTextCount: ((Int) -> Void)?
    
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
        context.coordinator.viewModel = viewModel
        checkDifferent(textView, context)
        updateHeight(textView)
        updateTextCount(textView)
    }
    
    public func makeCoordinator() -> TextViewCoordinator {
        return TextViewCoordinator(parent: self, viewModel: viewModel)
    }
    
    @MainActor
    private func updateHeight(_ textView: UITextView) {
        DispatchQueue.main.async {
            receiveTextViewHeight?(textView.contentSize.height)
        }
    }
    
    @MainActor
    private func updateTextCount(_ textView: UITextView) {
        DispatchQueue.main.async {
            var count: Int = 0
            
            let trimMode: TextViewTrimMode = viewModel(\.styleState.trimMode)
            
            switch trimMode {
            case .none:
                count = textView.text.count
            case .whitespaces:
                count = textView.text.trimmingCharacters(in: .whitespaces).count
            case .whitespacesAndNewlines:
                count = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).count
            case .blankWithWhitespaces:
                count = textView.text.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "").count
            case .blankWithWhitespacesAndNewlines:
                count = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "").count
            }
            
            receiveTextCount?(count)
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
        
        if let bgcolor = viewState.backgroundColor {
            textView.backgroundColor = UIColor(bgcolor)
        }
        
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
        
        if self.text.count > styleState.limitCount {
            let prefixText = textView.text.prefix(styleState.limitCount)
            textView.text = String(prefixText)
            self.text = String(prefixText)
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

private extension TextView {
    /// textView.text와 @Binding text가 다른지 체크하는 method
    ///
    /// 외부에서 @Binding text를 수정한 경우에 reassembleMode가 켜져 있다면 textView.text와 비교해서 적용시킨다.
    func checkDifferent(_ textView: UIViewType, _ context: Context) {
        if viewModel(\.reassembleMode) {
            DispatchQueue.main.async {
                if textView.text != self.text {
                    if self.text.isEmpty {
                        textView.text = ""
                    } else {
                        self.determineRangeAndReplacementText(textView, context)
                    }
                }
            }
        }
    }
    /// range랑 replacementText를 결정하는 method
    ///
    /// textView.text와 @Binding text를 비교해서 range랑 replacementText를 결정하고, ``replacementCondition(_:shouldChangeTextIn:replacementText:context:)``를 통해 최종적으로 적용시키는 여부를 결정한다.
    func determineRangeAndReplacementText(_ textView: UITextView, _ context: Context) {
        var differenceIndex: Int?
        let maxCount: Int = max(textView.text.count, self.text.count)
        
        for i in 0..<maxCount {
            let textViewIndex: String.Index? = textView.text.index(textView.text.startIndex, offsetBy: i, limitedBy: textView.text.endIndex)
            let bindTextIndex: String.Index? = self.text.index(self.text.startIndex, offsetBy: i, limitedBy: text.endIndex)
            
            var char1: Character?
            var char2: Character?
            
            if let textViewIndex {
                let limit = textView.text.distance(from: textView.text.startIndex, to: textViewIndex)
                char1 = textView.text.count > limit ? textView.text[textViewIndex] : nil
            }
            
            if let bindTextIndex {
                let limit = self.text.distance(from: self.text.startIndex, to: bindTextIndex)
                char2 = self.text.count > limit ? self.text[bindTextIndex] : nil
            }
            
            if char1 != char2 {
                if differenceIndex == nil {
                    differenceIndex = i
                }
            }
        }
        
        let range = NSRange(location: differenceIndex ?? .zero, length: textView.text.count - (differenceIndex ?? .zero))
        
        var replacementText: String = ""
        
        if let differenceIndex {
            replacementText = String(self.text.suffix(self.text.count - differenceIndex))
        }
        
        self.replacementCondition(textView, shouldChangeTextIn: range, replacementText: replacementText, context: context)
    }
    /// textView.text를 range랑 replacementText를 가지고 실제로 적용시킬지 말지 결정하는 method
    ///
    /// determineRangeAndReplacementText에 의해 결정된 range랑 replacementText를 가지고 inputBreakMode랑 TrimMode의 종류에 따라 textView에 적용시킬지 말지 결정한다.
    ///
    /// textView에 적용을 안시킬 경우에, @Binding text를 textView.text로 교체한다.
    func replacementCondition(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String, context: Context) {
        /// checkInputBreakMode으로 연속공백, 개행 막는다
        if context.coordinator.checkInputBreakMode(textView, range: range, replacementText: text) {
            let reassembleInputBreakText = self.reassembleInputBreak(text)
            let finalText = self.reassembleTrimMode(reassembleInputBreakText)
            
            if finalText.isEmpty {
                if self.text != textView.text {
                    self.text = textView.text
                }
                return
            }
            
            if context.coordinator.limitLineCondition(textView, shouldChangeTextIn: range, replacementText: finalText) {
                if self.text != textView.text {
                    self.text = textView.text
                }
                return
            }
            
            if self.checkLimitCountCondition(textView, shouldChangeTextIn: range, replacementText: text, context: context) {
                if self.text != textView.text {
                    self.text = textView.text
                }
                return
            }
            
            
            if let textRange = Range(range, in: textView.text) {
                textView.text = textView.text.replacingCharacters(in: textRange, with: finalText)
                
                if self.text != textView.text {
                    self.text = textView.text
                }
            }
            
        } else {
            self.text = textView.text
        }
    }
    /// limitCount에 걸리는지 체크하는 method
    ///
    /// textView.text에 replacementText를 append시키고 trimMode로 reassemble된 text를 가지고 비교해서 추가 될 text가 limitCount보다 over될 경우에
    /// over된 count만큼 replacementText를 짤라서 append시킨다.
    func checkLimitCountCondition(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String, context: Context) -> Bool {
        let newText = context.coordinator.makeNewText(textView, shouldChangeTextIn: range, replacementText: text)
        
        let changedText = self.reassembleTrimMode(newText)
        let basicText = self.reassembleTrimMode(textView.text)
        
        if changedText.count > viewModel(\.styleState.limitCount) {
            let prefixCount = max(0, viewModel(\.styleState.limitCount) - basicText.count)
            let prefixText = text.prefix(prefixCount)
            
            if !prefixText.isEmpty {
                textView.text.append(contentsOf: prefixText)
                self.text = textView.text
                textView.selectedRange = NSRange(location: textView.text.count, length: 0)
            }
            
            return true
        }
        
        return false
    }
}
