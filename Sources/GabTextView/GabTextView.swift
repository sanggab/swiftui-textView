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
        print("상갑 logEvent \(#function)")
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
            if viewModel(\.sizeMode) == .dynamic {
                receiveTextViewHeight?(textView.contentSize.height)
            }
        }
    }
    
    @MainActor
    private func updateTextCount(_ textView: UITextView) {
        DispatchQueue.main.async {
            var count: Int = 0
            var newText: String = ""
            
            let trimMode: TextViewTrimMode = viewModel(\.styleState.trimMode)
            
            switch trimMode {
            case .none:
                newText = textView.text
                count = textView.text.count
            case .whitespaces:
                newText = textView.text.trimmingCharacters(in: .whitespaces)
                count = textView.text.trimmingCharacters(in: .whitespaces).count
            case .whitespacesAndNewlines:
                newText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
                count = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).count
            case .blankWithWhitespaces:
                // TODO: last가 줄바꿈이다가 단어가 들어오면 단어와 단어 사이의 줄바꿈이 카운트로 인식되서 limitCount가 애매해질 수 있다.
                newText = textView.text.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "")
                count = textView.text.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "").count
            case .blankWithWhitespacesAndNewlines:
                newText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
                count = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "").count
            }
//            print("상갑 logEvent \(#function) newText: \(newText)")
//            print("상갑 logEvent \(#function) count: \(count)")
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
    // TODO: NSRange는 location과 length로 구성
    // TODO: location은 현재 textView에서 공백을 제외한 위치를 나타냄. ex) 하이 요 다음에 다라는 글자가 들어오면 공백은 제외하고 location은 4가 들어옴. 근데 문제는 자음을 입력하면 location이 4가 됫을 때, 모음이 들어와서 합쳐져도 location은 4
    // TODO: length는 delete시에 지워지는 값들을 의미
    func checkDifferent(_ textView: UIViewType, _ context: Context) {
        print("상갑 logEvent \(#function)")
        if viewModel(\.reassembleMode) != .none {
            DispatchQueue.main.async {
                if textView.text != self.text {
                    if self.text.isEmpty {
                        textView.text = ""
                    } else {
                        self.testReset(textView, context)
                    }
                }
            }
        }
    }
    
    func testReset(_ textView: UITextView, _ context: Context) {
        var differenceIndex: Int?
        let maxCount: Int = max(textView.text.count, self.text.count)
        
        print("상갑 logEvent \(#function) maxCount: \(maxCount)")
        print("상갑 logEvent \(#function) textView.text: \(Optional(textView.text))")
        print("상갑 logEvent \(#function) text: \(Optional(text))")
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
            
//            if char1 == char2 {
//                if let char1, let char2 {
//                    sameIndex = i
//                }
//            } else {
//                if differenceIndex == nil {
//                    differenceIndex = i
//                }
//            }
            
            if char1 != char2 {
                if differenceIndex == nil {
                    differenceIndex = i
                }
            }
        }
        
        print("상갑 logEvent \(#function) differenceIndex: \(differenceIndex)")
        let range = NSRange(location: differenceIndex ?? .zero, length: textView.text.count - (differenceIndex ?? .zero))
        
        var replacementText: String = ""
        
        if let differenceIndex {
            replacementText = String(self.text.suffix(self.text.count - differenceIndex))
        }
        
        print("상갑 logEvent \(#function) replacementText: \(replacementText)")
        print("상갑 logEvent \(#function) range: \(range)")
        
        self.replacementCondition(textView, shouldChangeTextIn: range, replacementText: replacementText, context: context)
    }
    
    func replacementCondition(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String, context: Context) {
        print("상갑 logEvent \(#function)")
        print("상갑 logEvent \(#function) replacementText: \(Optional(text))")
        print("상갑 logEvent \(#function) range: \(range)")
        
        if range.location == .zero {
            print("처음부터 바꾸는거니까 trim만 적용시켜도 될 듯")
            self.testLocationZero(textView, shouldChangeTextIn: range, replacementText: text, context: context)
//            if let textRange = Range(range, in: textView.text) {
//                // TODO: trim추가
//                textView.text = textView.text.replacingCharacters(in: textRange, with: text)
//                if self.text != textView.text {
//                    self.text = textView.text
//                }
//            }
        } else {
            // 기존 textViewl.text 뒤에 공백이 있는데 또 replacementText가 앞에 공백으로 시작하면 이상해져버림.. 그럴 땐 막아버리자
            if context.coordinator.checkInputBreakMode(textView, replacementText: text) {
                let reassembleText = viewModel(\.reassembleMode) != .trim ? self.reassembleInputBreak(text) : text
//                let reassembleText = self.reassembleInputBreak(text)
                print("상갑 logEvent \(#function) reassembleText: \(Optional(reassembleText))")
                if context.coordinator.limitLineCondition(textView, shouldChangeTextIn: range, replacementText: text) {
                    print("limitLineCondition")
                    self.text = textView.text
                    return
                }
                
                if self.checkLimitCountCondition(textView, shouldChangeTextIn: range, replacementText: text, context: context) {
                    print("checkLimitCountCondition")
                    if self.text != textView.text {
                        self.text = textView.text
                    }
                    return
                }
                
                if let textRange = Range(range, in: textView.text) {
                    let newText: String = viewModel(\.reassembleMode) == .trim ? self.reassembleTrimMode(textView.text.replacingCharacters(in: textRange, with: reassembleText)) : reassembleText
                    textView.text = newText
                    
                    if self.text != textView.text {
                        self.text = textView.text
                    }
                }
            } else {
                self.text = textView.text
            }
        }
    }
    
    func checkLimitCountCondition(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String, context: Context) -> Bool {
        let newText = context.coordinator.makeNewText(textView, shouldChangeTextIn: range, replacementText: text)
        
        let changedText = self.reassembleTrimMode(newText)
        let basicText = self.reassembleTrimMode(textView.text)
        
        print("상갑 logEvent \(#function) changedText: \(Optional(changedText))")
        print("상갑 logEvent \(#function) basicText: \(Optional(basicText))")
        
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

extension TextView {
    
    func testLocationZero(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String, context: Context) {
        let reassembleText = viewModel(\.reassembleMode) != .trim ? self.reassembleInputBreak(text) : text
        
        if let textRange = Range(range, in: textView.text) {
            let newText: String = viewModel(\.reassembleMode) == .trim ? self.reassembleTrimMode(textView.text.replacingCharacters(in: textRange, with: reassembleText)) : reassembleText
            textView.text = newText
            
            if self.text != textView.text {
                self.text = textView.text
            }
        } else {
            let newText: String = viewModel(\.reassembleMode) == .trim ? self.reassembleTrimMode(self.text) : self.text
            textView.text = newText
            
            if self.text != textView.text {
                self.text = textView.text
            }
        }
    }
}
