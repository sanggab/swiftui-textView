//
//  TextViewModel.swift
//  GabTextView
//
//  Created by Gab on 2024/07/30.
//

import SwiftUI

protocol TextViewFeatures {
    associatedtype State: Equatable
    associatedtype Action: Equatable
    
    func callAsFunction<V: Equatable>(_ keyPath: KeyPath<State, V>) -> V
    
    func action(_ action: Action)
}

class TextViewModel: ObservableObject, TextViewFeatures {
    typealias State = MainState
    typealias Action = MainAction
    
    
    // ------------------------------------------------------------------------------------ //
    struct ViewState: Equatable {
        var backgroundColor: Color = .white
        var textAlignment: NSTextAlignment = .natural
        var isEditable: Bool = true
        var isSelectable: Bool = true
        var dataDetectorTypes: UIDataDetectorTypes?
        var textContainerInset: UIEdgeInsets = UIEdgeInsets(top: 8,
                                                            left: 0,
                                                            bottom: 8,
                                                            right: 0)
        var usesStandardTextScaling: Bool = false
        var isFindInteractionEnabled: Bool = false
    }
    
    enum ViewAction: Equatable {
        case updateColor(Color)
        case updateTextAlignment(NSTextAlignment)
        case updateIsEditable(Bool)
        case updateIsSelectable(Bool)
        case updateDataDetectorTypes(UIDataDetectorTypes)
        case updateTextContainerInset(UIEdgeInsets)
        case updateUsesStandardTextScaling(Bool)
        case updateIsFindInteractionEnabled(Bool)
    }
    // ------------------------------------------------------------------------------------ //
    
    
    
    // ------------------------------------------------------------------------------------ //
    struct ScrollViewState: Equatable {
        var contentOffset: CGPoint = .zero
        var contentSize: CGSize = .zero
        var contentInset: UIEdgeInsets = .zero
        var isScrollEnabled: Bool = true
        var contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior = .automatic
        var automaticallyAdjustsScrollIndicatorInsets: Bool = true
        var isDirectionalLockEnabled: Bool = false
        var bounces: Bool = true
        var alwaysBounceVertical: Bool = false
        var alwaysBounceHorizontal: Bool = false
        var isPagingEnabled: Bool = false
        var showsVerticalScrollIndicator: Bool = true
        var showsHorizontalScrollIndicator: Bool = true
        var indicatorStyle: UIScrollView.IndicatorStyle = .default
        var verticalScrollIndicatorInsets: UIEdgeInsets = .zero
        var horizontalScrollIndicatorInsets: UIEdgeInsets = .zero
        var decelerationRate: UIScrollView.DecelerationRate = .normal
        var indexDisplayMode: UIScrollView.IndexDisplayMode?
        var delaysContentTouches: Bool = true
        var canCancelContentTouches: Bool = true
        var minimumZoomScale: CGFloat = 1.0
        var maximumZoomScale: CGFloat = 1.0
        var zoomScale: CGFloat = 1.0
        var bouncesZoom: Bool = true
        var scrollsToTop: Bool = true
        var keyboardDismissMode: UIScrollView.KeyboardDismissMode = .none
        var refreshControl: UIRefreshControl?
        var allowsKeyboardScrolling: Bool = true
    }
    
    enum ScrollViewAction: Equatable {
        case updateContentOffset(CGPoint)
        case updateContentSize(CGSize)
        case updateContentInset(UIEdgeInsets)
        case updateIsScrollEnabled(Bool)
        case updateContentInsetAdjustmentBehavior(UIScrollView.ContentInsetAdjustmentBehavior)
        case updateAutomaticallyAdjustsScrollIndicatorInsets(Bool)
        case updateIsDirectionalLockEnabled(Bool)
        case updateBounces(Bool)
        case updateAlwaysBounceVertical(Bool)
        case updateAlwaysBounceHorizontal(Bool)
        case updateIsPagingEnabled(Bool)
        case updateShowsVerticalScrollIndicator(Bool)
        case updateShowsHorizontalScrollIndicator(Bool)
        case updateIndicatorStyle(UIScrollView.IndicatorStyle)
        case updateVerticalScrollIndicatorInsets(UIEdgeInsets)
        case updateHorizontalScrollIndicatorInsets(UIEdgeInsets)
        case updateDecelerationRate(UIScrollView.DecelerationRate)
        case updateIndexDisplayMode(UIScrollView.IndexDisplayMode)
        case updateDelaysContentTouches(Bool)
        case updateCanCancelContentTouches(Bool)
        case updateMinimumZoomScale(CGFloat)
        case updateMaximumZoomScale(CGFloat)
        case updateZoomScale(CGFloat)
        case updateBouncesZoom(Bool)
        case updateScrollsToTop(Bool)
        case updateKeyboardDismissMode(UIScrollView.KeyboardDismissMode)
        case updateRefreshControl(UIRefreshControl)
        case updateAllowsKeyboardScrolling(Bool)
    }
    
    // ------------------------------------------------------------------------------------ //
    
    
    
    // ------------------------------------------------------------------------------------ //
    struct ContentPriorityState: Equatable {
        var contentPriority: TextViewContentPriority = .init()
    }
    
    enum ContentPriorityAction: Equatable {
        case updateSetContentHuggingPriority(ContentPriorityModel)
        case updateSetContentCompressionResistancePriority(ContentPriorityModel)
    }
    // ------------------------------------------------------------------------------------ //
    
    
    
    // ------------------------------------------------------------------------------------ //
    struct StyleState: Equatable {
        var appearance: TextViewAppearanceModel = .default
        var limitCount: Int = 999999
        var limitLine: Int = 999999
    }
    
    enum StyleAction: Equatable {
        case updateTextViewAppearanceModel(TextViewAppearanceModel)
        case updateTextAppearance(TextAppearanceType, TextAppearance)
        
        case updateLimitCount(Int)
        case updateLimitLine(Int)
    }
    // ------------------------------------------------------------------------------------ //
    
    
    // ------------------------------------------------------------------------------------ //
    struct TextContainerState: Equatable {
        var lineFragmentPadding: CGFloat = 5.0
        var lineBreakMode: NSLineBreakMode = .byWordWrapping
        var maximumNumberOfLines: Int = .zero
        var widthTracksTextView: Bool = false
        var heightTracksTextView: Bool = false
    }
    
    enum TextContainerAction: Equatable {
        case updateLlineFragmentPadding(CGFloat)
        case updateLineBreakMode(NSLineBreakMode)
        case updateMaximumNumberOfLines(Int)
        case updateWidthTracksTextView(Bool)
        case updateHeightTracksTextView(Bool)
    }
    // ------------------------------------------------------------------------------------ //
    
    
    // ------------------------------------------------------------------------------------ //
    struct MainState: Equatable {
        var viewState: ViewState = .init()
        var scrollViewState: ScrollViewState = .init()
        var contentPriorityState: ContentPriorityState = .init()
        var styleState: StyleState = .init()
        var textContainerState: TextContainerState = .init()
    }
    
    enum MainAction: Equatable {
        case updateViewState(ViewAction)
        case updateScrollViewState(ScrollViewAction)
        case updateContentPriorityState(ContentPriorityAction)
        case updateStyleState(StyleAction)
        case updateTextContainerState(TextContainerAction)
    }
    // ------------------------------------------------------------------------------------ //
    
    @Published private var state: MainState = .init()
    
    func callAsFunction<V>(_ keyPath: KeyPath<MainState, V>) -> V where V : Equatable {
        return state[keyPath: keyPath]
    }
    
    func action(_ action: MainAction) {
        switch action {
        case .updateViewState(let action):
            viewAction(action)
        case .updateScrollViewState(let action):
            scrollViewAction(action)
        case .updateContentPriorityState(let action):
            contentPriorityAction(action)
        case .updateStyleState(let action):
            styleAction(action)
        case .updateTextContainerState(let action):
            textContainerAction(action)
        }
    }
}

private extension TextViewModel {
    func viewAction(_ action: ViewAction) {
        switch action {
        case .updateColor(let color):
            update(\.viewState.backgroundColor, value: color)
            
        case .updateTextAlignment(let alignment):
            update(\.viewState.textAlignment, value: alignment)
            
        case .updateIsEditable(let state):
            update(\.viewState.isEditable, value: state)
            
        case .updateIsSelectable(let state):
            update(\.viewState.isEditable, value: state)
            
        case .updateDataDetectorTypes(let dataDetectorTypes):
            update(\.viewState.dataDetectorTypes, value: dataDetectorTypes)
            
        case .updateTextContainerInset(let edgeInsets):
            update(\.viewState.textContainerInset, value: edgeInsets)
            
        case .updateUsesStandardTextScaling(let state):
            update(\.viewState.usesStandardTextScaling, value: state)
            
        case .updateIsFindInteractionEnabled(let edgeInsets):
            update(\.viewState.isFindInteractionEnabled, value: edgeInsets)
        }
    }
    
}

private extension TextViewModel {
    func scrollViewAction(_ action: ScrollViewAction) {
        switch action {
        case .updateContentOffset(let point):
            update(\.scrollViewState.contentOffset, value: point)
            
        case .updateContentSize(let size):
            update(\.scrollViewState.contentSize, value: size)
            
        case .updateContentInset(let edgeInsets):
            update(\.scrollViewState.contentInset, value: edgeInsets)
            
        case .updateIsScrollEnabled(let state):
            update(\.scrollViewState.isScrollEnabled, value: state)
            
        case .updateContentInsetAdjustmentBehavior(let behavior):
            update(\.scrollViewState.contentInsetAdjustmentBehavior, value: behavior)
            
        case .updateAutomaticallyAdjustsScrollIndicatorInsets(let state):
            update(\.scrollViewState.automaticallyAdjustsScrollIndicatorInsets, value: state)
            
        case .updateIsDirectionalLockEnabled(let state):
            update(\.scrollViewState.isDirectionalLockEnabled, value: state)
            
        case .updateBounces(let state):
            update(\.scrollViewState.bounces, value: state)
            
        case .updateAlwaysBounceVertical(let state):
            update(\.scrollViewState.alwaysBounceVertical, value: state)
            
        case .updateAlwaysBounceHorizontal(let state):
            update(\.scrollViewState.alwaysBounceHorizontal, value: state)
            
        case .updateIsPagingEnabled(let state):
            update(\.scrollViewState.isPagingEnabled, value: state)
            
        case .updateShowsVerticalScrollIndicator(let state):
            update(\.scrollViewState.showsVerticalScrollIndicator, value: state)
            
        case .updateShowsHorizontalScrollIndicator(let state):
            update(\.scrollViewState.showsHorizontalScrollIndicator, value: state)
            
        case .updateIndicatorStyle(let style):
            update(\.scrollViewState.indicatorStyle, value: style)
            
        case .updateVerticalScrollIndicatorInsets(let edgeInsets):
            update(\.scrollViewState.verticalScrollIndicatorInsets, value: edgeInsets)
            
        case .updateHorizontalScrollIndicatorInsets(let edgeInsets):
            update(\.scrollViewState.horizontalScrollIndicatorInsets, value: edgeInsets)
            
        case .updateDecelerationRate(let rate):
            update(\.scrollViewState.decelerationRate, value: rate)
            
        case .updateIndexDisplayMode(let mode):
            update(\.scrollViewState.indexDisplayMode, value: mode)
            
        case .updateDelaysContentTouches(let state):
            update(\.scrollViewState.delaysContentTouches, value: state)
            
        case .updateCanCancelContentTouches(let state):
            update(\.scrollViewState.canCancelContentTouches, value: state)
            
        case .updateMinimumZoomScale(let scale):
            update(\.scrollViewState.minimumZoomScale, value: scale)
            
        case .updateMaximumZoomScale(let scale):
            update(\.scrollViewState.maximumZoomScale, value: scale)
            
        case .updateZoomScale(let scale):
            update(\.scrollViewState.zoomScale, value: scale)
            
        case .updateBouncesZoom(let state):
            update(\.scrollViewState.bouncesZoom, value: state)
            
        case .updateScrollsToTop(let state):
            update(\.scrollViewState.scrollsToTop, value: state)
            
        case .updateKeyboardDismissMode(let mode):
            update(\.scrollViewState.keyboardDismissMode, value: mode)
            
        case .updateRefreshControl(let control):
            update(\.scrollViewState.refreshControl, value: control)
            
        case .updateAllowsKeyboardScrolling(let state):
            update(\.scrollViewState.allowsKeyboardScrolling, value: state)
        }
    }
}

private extension TextViewModel {
    func contentPriorityAction(_ action: ContentPriorityAction) {
        switch action {
        case .updateSetContentHuggingPriority(let model):
            update(\.contentPriorityState.contentPriority.hugging, value: model)
            
        case .updateSetContentCompressionResistancePriority(let model):
            update(\.contentPriorityState.contentPriority.compressionResistance, value: model)
        }
    }
}

private extension TextViewModel {
    func styleAction(_ action: StyleAction) {
        switch action {
        case .updateTextViewAppearanceModel(let appearance):
            update(\.styleState.appearance, value: appearance)
            
        case .updateTextAppearance(let type, let appearance):
            switch type {
            case .focus:
                update(\.styleState.appearance.focus, value: appearance)
            case .noneFocus:
                update(\.styleState.appearance.noneFocus, value: appearance)
            }
            
        case .updateLimitCount(let count):
            update(\.styleState.limitCount, value: count)
            
        case .updateLimitLine(let line):
            update(\.styleState.limitLine, value: line)
        }
    }
}

private extension TextViewModel {
    func textContainerAction(_ action: TextContainerAction) {
        switch action {
        case .updateLlineFragmentPadding(let padding):
            update(\.textContainerState.lineFragmentPadding, value: padding)
        case .updateLineBreakMode(let mode):
            update(\.textContainerState.lineBreakMode, value: mode)
        case .updateMaximumNumberOfLines(let line):
            update(\.textContainerState.maximumNumberOfLines, value: line)
        case .updateWidthTracksTextView(let state):
            update(\.textContainerState.widthTracksTextView, value: state)
        case .updateHeightTracksTextView(let state):
            update(\.textContainerState.heightTracksTextView, value: state)
        }
    }
}

private extension TextViewModel {
    func update<V>(_ keyPath: WritableKeyPath<State, V>, value: V) where V: Equatable {
        state[keyPath: keyPath] = value
    }
}
