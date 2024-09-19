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
//        if textView.text != text {
//            if textView.text.count == text.count {
//                sameIndex(textView)
//            } else {
//                textView.text.count > text.count ? textViewOverIndex(textView, context) : bindingTextOverIndex(textView, context)
//            }
//        }
        
        if textView.text != text {
            if text.isEmpty {
                textView.text = ""
            } else {
//                getReplacementText(textView, context)
                testReset(textView, context)
            }
        }
    }
    
    func getReplacementText(_ textView: UIViewType, _ context: Context) {
        let result: CheckTypeAlias = textView.text.count > text.count ? over(textView, context) : down(textView, context)
        
        lastCondition(textView, result: result, context: context)
    }
    // TODO: bind text는 최종적으로 append가 아닌 교체. 즉, down이랑 다름 그래서 textView.text = text 이런식으로 적용해야하는 느낌
    func over(_ textView: UIViewType, _ context: Context) -> CheckTypeAlias {
        var differenceIndex: Int?
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
            
//            print("상갑 logEvent \(#function) char1: \(char1)")
//            print("상갑 logEvent \(#function) char2: \(char2)")
            
            if char1 != char2, let char2 {
                replacementText.append(String(char2))
                if differenceIndex == nil {
                    differenceIndex = i
                }
            }
        }
        
        print("상갑 logEvent \(#function) differenceIndex: \(differenceIndex)")
        print("상갑 logEvent \(#function) replacementText: \(Optional(replacementText))")
        
        
        let reassembleText = reassembleInputBreak(textView, replacementText: self.text)
        
        let range: NSRange = NSRange(location: 0, length: textView.text.count)
        
        let result: CheckTypeAlias = (range, reassembleText)
        
        return result
    }
    // TODO: 앞으로 들어올 text가 기존 textView.text에 새로 추가되는(append)면 상관이 없는데
    // TODO: 하이에서 하 이 요 같이 그냥 바꿔버리는거면 문제가 발생. - 노트 필기
    func down(_ textView: UIViewType, _ context: Context) -> CheckTypeAlias {
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
        }
        
        print("상갑 logEvent \(#function) differenceIndex: \(differenceIndex)")
        print("상갑 logEvent \(#function) replacementText: \(Optional(replacementText))")
        
        let range: NSRange = NSRange(location: differenceIndex ?? .zero, length: textView.text.count - (differenceIndex ?? .zero))
        
        let reassembleText = reassembleInputBreak(textView, replacementText: replacementText)
        
        let result = CheckTypeAlias(range, reassembleText)
        
        return result
    }
}

private extension TextView {
    // TODO: trimMode랑 inputBreakMode 적용시키기
    // TODO: 여기서 생각해야될게 여기는 updateUIView에서 textView.text하고 binding text가 다를 경우에만 들어옴.
    // TODO: 결국엔 외부에서 binding text를 수정한 경우에 들어온다는 건데
    // TODO: 외부에서 수정했으니 결국엔 키보드가 올라간 경우가 있을 거고, 아닌 경우가 있을 거임
    // TODO: 그러면 결국엔 모든 케이스를 대응하는 최고의 방법은 현재 textView.text하고 binding text하고 다른 점을 뽑아내서
    // TODO: 그게 inputBreakMode에 걸리는지 비교 하고
    // TODO: trimMode로 짤라내는것
    func replacementTextView(_ textView: UITextView, range: NSRange, replacementText text: String, context: Context) {
        print("상갑 logEvent \(#function) range: \(range)")
        
        DispatchQueue.main.async {
            if context.coordinator.checkInputBreakMode(textView, replacementText: text) {
                print("아아 이것은 찬성")
            } else {
                print("아아 이거는 거절")
            }
            
            if context.coordinator.limitLineCondition(textView, shouldChangeTextIn: range, replacementText: text) {
                self.text = textView.text
                
                return
            }
            
            if context.coordinator.limitCountCondition(textView, shouldChangeTextIn: range, replacementText: text) {
                if self.text != textView.text {
                    self.text = textView.text
                }
                
                return
            }
            
            if context.coordinator.limitNewLineAndSpaceCondition(textView, shouldChangeTextIn: range, replacementText: text) {
                self.text = textView.text
                
                return
            }
            // TODO: textRange 오류 수정해라 trim4했다가 trim5 하니까 에러 뜸;
            if let textRange = Range(range, in: textView.text) {
                textView.text = textView.text.replacingCharacters(in: textRange, with: text)
            }
        }
    }
}

private extension TextView {
    
    func lastCondition(_ textView: UITextView, result: CheckTypeAlias, context: Context) {
        print("상갑 logEvent \(#function)")
        print("상갑 logEvent \(#function) result: \(result)")
        DispatchQueue.main.async {
//            let reassembleTrimText = self.reassembleTrimMode(result.replacementText)
            
//            print("상갑 logEvent \(#function) reassembleText: \(Optional(reassembleTrimText))")
            
            if result.replacementText.isEmpty {
                print("없으면 그냥 치워!")
                self.text = textView.text
                return
            }
            
            if self.checkLimitLine(textView, result: result, context: context) {
                print("checkLimitLine")
                self.text = textView.text
                
            }
            
            if self.checkLimitTextCount(textView, result: result, context: context) {
                print("checkLimitTextCount")
                self.text = textView.text
                return
            }
            
            if let textRange = Range(result.range, in: textView.text) {
                textView.text = textView.text.replacingCharacters(in: textRange, with: result.replacementText)
                self.text = textView.text
            }
        }
    }
    
    func checkLimitLine(_ textView: UITextView, result: CheckTypeAlias, context: Context) -> Bool {
        let newText = context.coordinator.makeNewText(textView, shouldChangeTextIn: result.range, replacementText: result.replacementText)
        
        let textHeight = newText.boundingRect(with: CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude),
                                                  options: .usesLineFragmentOrigin,
                                                  attributes: [NSAttributedString.Key.font: textView.font ?? UIFont.boldSystemFont(ofSize: 15)],
                                                  context: nil).height
        
        let lines = Int(textHeight / (textView.font?.lineHeight ?? 0))
        
        if lines > viewModel(\.styleState.limitLine) {
            return true
        }
        
        return false
    }
    
    func checkLimitTextCount(_  textView: UITextView, result: CheckTypeAlias, context: Context) -> Bool {
        let newText = context.coordinator.makeNewText(textView, shouldChangeTextIn: result.range, replacementText: result.replacementText)
        
        let trimNewText: String = reassembleTrimMode(newText)
        let trimOriginText: String = reassembleTrimMode(textView.text)
        
        print("상갑 logEvent \(#function) trimNewText.count: \(trimNewText.count)")
        print("상갑 logEvent \(#function) trimOriginText.count: \(trimOriginText.count)")
        
        if trimNewText.count >= viewModel(\.styleState.limitCount) {
            print("짤라")
            let prefixCount = max(0, viewModel(\.styleState.limitCount) - trimOriginText.count)
            print("상갑 logEvent \(#function) prefixCount: \(prefixCount)")
            let prefixText = result.replacementText.prefix(prefixCount)
            print("상갑 logEvent \(#function) prefixText: \(prefixText)")
            
            if prefixCount > .zero {
                textView.text.append(contentsOf: prefixText)
                textView.selectedRange = NSRange(location: textView.text.count, length: 0)
            }
            
            return true
        }
        
        return false
    }
    
    func testReset(_ textView: UITextView, _ context: Context) {
        var sameIndex: Int?
        var differenceIndex: Int?
        var maxCount: Int = max(textView.text.count, self.text.count)
        
        print("상갑 logEvent \(#function) maxCount: \(maxCount)")
        print("상갑 logEvent \(#function) text: \(Optional(textView.text))")
        print("상갑 logEvent \(#function) text: \(Optional(text))")
        for i in 0..<maxCount {
            let textViewIndex: String.Index? = textView.text.index(textView.text.startIndex, offsetBy: i, limitedBy: textView.text.endIndex)
            let bindTextIndex: String.Index? = text.index(text.startIndex, offsetBy: i, limitedBy: text.endIndex)
            
            var char1: Character?
            var char2: Character?
            
            if let textViewIndex {
                let limit = textView.text.distance(from: textView.text.startIndex, to: textViewIndex)
                char1 = textView.text.count > limit ? textView.text[textViewIndex] : nil
            }
            
            if let bindTextIndex {
                let limit = text.distance(from: text.startIndex, to: bindTextIndex)
                char2 = text.count > limit ? text[bindTextIndex] : nil
            }
            
            print("상갑 logEvent \(#function) char1: \(char1)")
            print("상갑 logEvent \(#function) char2: \(char2)")
            
//            if let char1, let char2 {
//                if char1 == char2 {
//                    sameIndex = i
//                } else {
//                    if differenceIndex == nil {
//                        differenceIndex = i
//                    }
//                }
//            }
            
            if char1 == char2 {
                if let char1, let char2 {
                    sameIndex = i
                }
            } else {
                if differenceIndex == nil {
                    differenceIndex = i
                }
            }
        }
        
        print("상갑 logEvent \(#function) sameIndex: \(sameIndex)")
        print("상갑 logEvent \(#function) differenceIndex: \(differenceIndex)")
        let range = NSRange(location: differenceIndex ?? .zero, length: textView.text.count - (differenceIndex ?? .zero))
        
        var replacementText: String?
        
        if let differenceIndex {
            replacementText = String(text.suffix(text.count - differenceIndex))
        }
        
        print("상갑 logEvent \(#function) replacementText: \(replacementText)")
        print("상갑 logEvent \(#function) range: \(range)")
        
        if let replacementText {
            if let textRange = Range(range, in: textView.text) {
                textView.text = textView.text.replacingCharacters(in: textRange, with: replacementText)
            }
        }
    }
    
    func textShowChange(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) {
        
    }
}

//
//func textViewOverIndex(_ textView: UIViewType, _ context: Context) {
//    print("상갑 logEvent \(#function)")
//    var sameIndex: Int?
//    var replacementText: String = ""
//    
//    for i in 0..<textView.text.count {
//        let textViewIndex: String.Index? = textView.text.index(textView.text.startIndex, offsetBy: i, limitedBy: textView.text.endIndex)
//        let bindTextIndex: String.Index? = text.index(text.startIndex, offsetBy: i, limitedBy: text.endIndex)
//        
//        var char1: Character?
//        var char2: Character?
//        
//        if let textViewIndex {
//            char1 = textView.text[textViewIndex]
//        }
//        
//        if let bindTextIndex {
//            let limit = text.distance(from: text.startIndex, to: bindTextIndex)
//            char2 = text.count > limit ? text[bindTextIndex] : nil
//        }
//        
//        // TODO: 둘이 다를 경우에, 그때 replacementText에 추가
//        if char1 == char2 {
//            /// i에 +1 시키는 이유는 해당 인덱스 다음부터 달라지는 char가 나오기 때문에
//            sameIndex = i + 1
//        } else {
//            if let char2 {
//                replacementText.append(String(char2))
//            }
//        }
//        print("상갑 logEvent \(#function) i: \(i)")
//        print("상갑 logEvent \(#function) char1: \(char1)")
//        print("상갑 logEvent \(#function) char2: \(char2)")
//    }
//    
//    print("상갑 logEvent \(#function) sameIndex: \(sameIndex)")
//    print("상갑 logEvent \(#function) replacementText: \(replacementText)")
//    print("상갑 logEvent \(#function) replacementText count: \(replacementText.count)")
//    
//    /// 일치한 Index가 있으면 prefix로 자르고 덧 붙여서 사용
//    if let sameIndex {
//        let prefixText = textView.text.prefix(sameIndex)
//        let newText = prefixText.appending(replacementText)
//        print("상갑 logEvent \(#function) prefixText: \(prefixText)")
//        print("상갑 logEvent \(#function) newText: \(newText)")
//        let range = NSRange(location: sameIndex, length: textView.text.count - sameIndex)
//        replacementTextView(textView, range: range, replacementText: "", context: context)
//        print("1111111")
//    } else {
//        /// 일치한 Index가 없고 replacementText가 존재한다면 그냥 덮어쓰기
//        if !replacementText.isEmpty {
//            textView.text = replacementText
//            print("22222222")
////                let range = NSRange(location: 0, length: replacementText.count)
////                replacementTextView(textView, range: range, replacement: replacementText)
//        } else {
//            print("그대로")
//            textView.text = text
//        }
//    }
//}
//
//func bindingTextOverIndex(_ textView: UIViewType, _ context: Context) {
//    print("상갑 logEvent \(#function)")
//    var differenceIndex: Int?
//    var replacementText: String = ""
//    
//    for i in 0..<text.count {
//        let textViewIndex: String.Index? = textView.text.index(textView.text.startIndex, offsetBy: i, limitedBy: textView.text.endIndex)
//        let bindTextIndex: String.Index? = text.index(text.startIndex, offsetBy: i, limitedBy: text.endIndex)
//        
//        var char1: Character?
//        var char2: Character?
//        
//        if let textViewIndex {
//            let limit = textView.text.distance(from: textView.text.startIndex, to: textViewIndex)
//            
//            char1 = textView.text.count > limit ? textView.text[textViewIndex] : nil
//        }
//        
//        
//        if let bindTextIndex {
//            char2 = text[bindTextIndex]
//        }
//        
//        if char1 != char2, let char2 {
//            replacementText.append(String(char2))
//            if differenceIndex == nil {
//                differenceIndex = i
//            }
//        }
//        print("상갑 logEvent \(#function) i: \(i)")
//        print("상갑 logEvent \(#function) char1: \(char1)")
//        print("상갑 logEvent \(#function) char2: \(char2)")
//    }
//    
//    print("상갑 logEvent \(#function) differenceIndex: \(differenceIndex)")
//    print("상갑 logEvent \(#function) replacementText: \(replacementText)")
//    print("상갑 logEvent \(#function) replacementText count: \(replacementText.count)")
//    
//    if !replacementText.isEmpty {
//        if let differenceIndex {
//            /// differenceIndex를 그대로 쓰는 이유는 char1과 char2가 다를 경우에 differenceIndex를 세팅하는 시점이기 때문에
//            let prefixText = textView.text.prefix(differenceIndex)
//            let newText = prefixText.appending(replacementText)
//            print("상갑 logEvent \(#function) prefixText: \(prefixText)")
//            print("상갑 logEvent \(#function) newText: \(newText)")
////                textView.text = newText
//            
//            let range = NSRange(location: differenceIndex, length: 0)
//            print("상갑 logEvent \(#function) range: \(range)")
//            replacementTextView(textView, range: range, replacementText: replacementText, context: context)
//            print("33333333")
//        } else {
//            /// 나올 경우 zero
//            print("4444444444")
//            textView.text = text
//        }
//    } else {
//        print("555555555")
//    }
//}
//
//func sameIndex(_ textView: UIViewType) {
//    print("상갑 logEvent \(#function)")
//    textView.text = text
//}
