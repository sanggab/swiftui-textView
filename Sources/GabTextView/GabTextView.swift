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
    // TODO: Coordinator 갱신 문제 해결하기
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

private extension TextView {
    // TODO: NSRange는 location과 length로 구성
    // TODO: location은 현재 textView에서 공백을 제외한 위치를 나타냄. ex) 하이 요 다음에 다라는 글자가 들어오면 공백은 제외하고 location은 4가 들어옴. 근데 문제는 자음을 입력하면 location이 4가 됫을 때, 모음이 들어와서 합쳐져도 location은 4
    // TODO: length는 delete시에 지워지는 값들을 의미
    func checkDifferent(_ textView: UIViewType, _ context: Context) {
        print("상갑 logEvent \(#function)")
        if textView.text != text {
            if textView.text.count == text.count {
                sameIndex(textView)
            } else {
                textView.text.count > text.count ? textViewOverIndex(textView, context) : bindingTextOverIndex(textView, context)
            }
        }
    }
    
    func textViewOverIndex(_ textView: UIViewType, _ context: Context) {
        print("상갑 logEvent \(#function)")
        var sameIndex: Int?
        var replacementText: String = ""
        
        for i in 0..<textView.text.count {
            let textViewIndex: String.Index? = textView.text.index(textView.text.startIndex, offsetBy: i, limitedBy: textView.text.endIndex)
            let bindTextIndex: String.Index? = text.index(text.startIndex, offsetBy: i, limitedBy: text.endIndex)
            
            var char1: Character?
            var char2: Character?
            
            if let textViewIndex {
                char1 = textView.text[textViewIndex]
            }
            
            if let bindTextIndex {
                let limit = text.distance(from: text.startIndex, to: bindTextIndex)
                char2 = text.count > limit ? text[bindTextIndex] : nil
            }
            
            // TODO: 둘이 다를 경우에, 그때 replacementText에 추가
            if char1 == char2 {
                /// i에 +1 시키는 이유는 해당 인덱스 다음부터 달라지는 char가 나오기 때문에
                sameIndex = i + 1
            } else {
                if let char2 {
                    replacementText.append(String(char2))
                }
            }
//            print("상갑 logEvent \(#function) i: \(i)")
//            print("상갑 logEvent \(#function) char1: \(char1)")
//            print("상갑 logEvent \(#function) char2: \(char2)")
        }
        
        print("상갑 logEvent \(#function) sameIndex: \(sameIndex)")
        print("상갑 logEvent \(#function) replacementText: \(replacementText)")
        print("상갑 logEvent \(#function) replacementText count: \(replacementText.count)")
        
        /// 일치한 Index가 있으면 prefix로 자르고 덧 붙여서 사용
        if let sameIndex {
            let prefixText = textView.text.prefix(sameIndex)
            let newText = prefixText.appending(replacementText)
            print("상갑 logEvent \(#function) prefixText: \(prefixText)")
            print("상갑 logEvent \(#function) newText: \(newText)")
            let range = NSRange(location: sameIndex, length: textView.text.count - sameIndex)
            replacementTextView(textView, range: range, replacementText: "", context: context)
            
        } else {
            /// 일치한 Index가 없고 replacementText가 존재한다면 그냥 덮어쓰기
            if !replacementText.isEmpty {
                textView.text = replacementText
//                let range = NSRange(location: 0, length: replacementText.count)
//                replacementTextView(textView, range: range, replacement: replacementText)
            }
        }
    }
    
    func bindingTextOverIndex(_ textView: UIViewType, _ context: Context) {
        print("상갑 logEvent \(#function)")
        var differenceIndex: Int?
        var replacementText: String = ""
        
        for i in 0..<text.count {
            let textViewIndex: String.Index? = textView.text.index(textView.text.startIndex, offsetBy: i, limitedBy: textView.text.endIndex)
            let bindTextIndex: String.Index? = text.index(text.startIndex, offsetBy: i, limitedBy: text.endIndex)
            
            var char1: Character?
            var char2: Character?
            
            if let textViewIndex {
                let limit = textView.text.distance(from: textView.text.startIndex, to: textViewIndex)
                
                char1 = textView.text.count > limit ? textView.text[textViewIndex] : nil
            }
            
            
            if let bindTextIndex {
                char2 = text[bindTextIndex]
            }
            
            if char1 != char2, let char2 {
                replacementText.append(String(char2))
                if differenceIndex == nil {
                    differenceIndex = i
                }
            }
//            print("상갑 logEvent \(#function) i: \(i)")
//            print("상갑 logEvent \(#function) char1: \(char1)")
//            print("상갑 logEvent \(#function) char2: \(char2)")
        }
        
        print("상갑 logEvent \(#function) differenceIndex: \(differenceIndex)")
        print("상갑 logEvent \(#function) replacementText: \(replacementText)")
        print("상갑 logEvent \(#function) replacementText count: \(replacementText.count)")
        
        if !replacementText.isEmpty {
            if let differenceIndex {
                /// differenceIndex를 그대로 쓰는 이유는 char1과 char2가 다를 경우에 differenceIndex를 세팅하는 시점이기 때문에
                let prefixText = textView.text.prefix(differenceIndex)
                let newText = prefixText.appending(replacementText)
                print("상갑 logEvent \(#function) prefixText: \(prefixText)")
                print("상갑 logEvent \(#function) newText: \(newText)")
//                textView.text = newText
                let range = NSRange(location: textView.text.count, length: 0)
                print("상갑 logEvent \(#function) range: \(range)")
                replacementTextView(textView, range: range, replacementText: replacementText, context: context)
                
            } else {
                /// 나올 경우 zero
            }
        }
    }
    
    func sameIndex(_ textView: UIViewType) {
        print("상갑 logEvent \(#function)")
        textView.text = text
    }
}

private extension TextView {
    // TODO: trimMode랑 inputBreakMode 적용시키기
    func replacementTextView(_ textView: UITextView, range: NSRange, replacementText text: String, context: Context) {
        print("상갑 logEvent \(#function) range: \(range)")
        
        DispatchQueue.main.async {
            if context.coordinator.checkInputBreakMode(textView, replacementText: text) {
                print("아아 이것은 찬성")
            } else {
                print("아아 이거는 거절")
            }
            
            test(textView, replacementText: text)
            
            
            if !context.coordinator.limitLineCondition(textView, shouldChangeTextIn: range, replacementText: text) {
                self.text = textView.text
                
                return
            }
            
            if !context.coordinator.limitCountCondition(textView, shouldChangeTextIn: range, replacementText: text) {
                if self.text != textView.text {
                    self.text = textView.text
                }
                
                return
            }
            
            if !context.coordinator.limitNewLineAndSpaceCondition(textView, shouldChangeTextIn: range, replacementText: text) {
                self.text = textView.text
                
                return
            }
            
            if let textRange = Range(range, in: textView.text) {
                textView.text = textView.text.replacingCharacters(in: textRange, with: text)
            }
        }
    }
}

private extension TextView {
    func test(_ textView: UITextView, replacementText: String) {
        var text = replacementText
        
        
    }
}
