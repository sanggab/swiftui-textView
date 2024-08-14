//
//  GabTextView + ScrollViewModifier.swift
//  GabTextView
//
//  Created by Gab on 2024/08/13.
//

import SwiftUI

// MARK: - ScrollView State Modifier
public extension TextView {
    /// The point at which the origin of the content view is offset from the origin of the scroll view.
    ///
    /// The default value is CGPointZero.
    func contentOffset(_ offset: CGPoint) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateContentOffset(offset)))
        return view
    }
    /// The size of the content view.
    ///
    /// The unit of size is points. The default size is CGSizeZero.
    func contentSize(_ size: CGSize) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateContentSize(size)))
        return view
    }
    /// The custom distance that the content view is inset from the safe area or scroll view edges.
    ///
    /// Use this property to extend the space between your content and the edges of the content view. The unit of size is points. The default value is zero.
    func contentInset(_ edgeInsets: UIEdgeInsets) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateContentInset(edgeInsets)))
        return view
    }
    /// A Boolean value that determines whether scrolling is enabled.
    ///
    /// The default value is true, which indicates that scrolling is enabled. Setting the value to false disables scrolling.
    /// When scrolling is disabled, the scroll view doesn’t accept touch events; it forwards them up the responder chain.
    func isScrollEnabled(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateIsScrollEnabled(state)))
        return view
    }
    /// The behavior for determining the adjusted content offsets.
    ///
    /// This property specifies how the safe area insets are used to modify the content area of the scroll view. The default value of this property is UIScrollView.ContentInsetAdjustmentBehavior.automatic.
    func contentInsetAdjustmentBehavior(_ behavior: UIScrollView.ContentInsetAdjustmentBehavior) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateContentInsetAdjustmentBehavior(behavior)))
        return view
    }
    /// A Boolean value that indicates whether the system automatically adjusts the scroll indicator insets.
    ///
    /// The default value is true.
    func automaticallyAdjustsScrollIndicatorInsets(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateAutomaticallyAdjustsScrollIndicatorInsets(state)))
        return view
    }
    /// A Boolean value that determines whether scrolling is disabled in a particular direction.
    ///
    /// If this property is false, scrolling is permitted in both horizontal and vertical directions. If this property is true and the user begins dragging in one general direction (horizontally or vertically), the scroll view disables scrolling in the other direction. If the drag direction is diagonal, then scrolling doesn’t lock and the user can drag in any direction until the drag completes. The default value is false.
    func isDirectionalLockEnabled(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateIsDirectionalLockEnabled(state)))
        return view
    }
    /// A Boolean value that controls whether the scroll view bounces past the edge of content and back again.
    ///
    /// If the value of this property is true, the scroll view bounces when it encounters a boundary of the content. Bouncing visually indicates that scrolling has reached an edge of the content. If the value is false, scrolling stops immediately at the content boundary without bouncing. The default value is true.
    func bounces(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateBounces(state)))
        return view
    }
    /// A Boolean value that determines whether bouncing always occurs when vertical scrolling reaches the end of the content.
    ///
    /// If the value of this property is true and ``bounces(_:)`` is true, the scroll view allows vertical dragging even if the content is smaller than the bounds of the scroll view. The default value is false.

    func alwaysBounceVertical(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateAlwaysBounceVertical(state)))
        return view
    }
    /// A Boolean value that determines whether bouncing always occurs when horizontal scrolling reaches the end of the content view.
    ///
    /// If the value of this property is true and ``bounces(_:)`` is true, the scroll view allows horizontal dragging even if the content is smaller than the bounds of the scroll view. The default value is false.

    func alwaysBounceHorizontal(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateAlwaysBounceHorizontal(state)))
        return view
    }
    /// A Boolean value that determines whether paging is enabled for the scroll view.
    ///
    /// If the value of this property is true, the scroll view stops on multiples of the scroll view’s bounds when the user scrolls. The default value is false.
    func isPagingEnabled(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateIsPagingEnabled(state)))
        return view
    }
    /// A Boolean value that controls whether the vertical scroll indicator is visible.
    ///
    /// The default value is true. The indicator is visible while tracking is underway and fades out after tracking.
    func showsVerticalScrollIndicator(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateShowsVerticalScrollIndicator(state)))
        return view
    }
    /// A Boolean value that controls whether the horizontal scroll indicator is visible.
    ///
    /// The default value is true. The indicator is visible while tracking is underway and fades out after tracking.
    func showsHorizontalScrollIndicator(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateShowsHorizontalScrollIndicator(state)))
        return view
    }
    /// The style of the scroll indicators.
    ///
    /// The default style is UIScrollView.IndicatorStyle.default. See UIScrollView.IndicatorStyle for descriptions of these constants.
    func indicatorStyle(_ indicatorStyle: UIScrollView.IndicatorStyle) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateIndicatorStyle(indicatorStyle)))
        return view
    }
    /// The vertical distance the scroll indicators are inset from the edge of the scroll view.
    ///
    /// The default value is zero.
    func verticalScrollIndicatorInsets(_ edgeInsets: UIEdgeInsets) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateVerticalScrollIndicatorInsets(edgeInsets)))
        return view
    }
    /// The horizontal distance the scroll indicators are inset from the edge of the scroll view.
    ///
    /// The default value is zero.
    func horizontalScrollIndicatorInsets(_ edgeInsets: UIEdgeInsets) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateHorizontalScrollIndicatorInsets(edgeInsets)))
        return view
    }
    /// A floating-point value that determines the rate of deceleration after the user lifts their finger.
    ///
    /// The default rate is normal. For possible deceleration rates, see UIScrollView.DecelerationRate.
    func decelerationRate(_ rate: UIScrollView.DecelerationRate) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateDecelerationRate(rate)))
        return view
    }
    /// The manner in which the index appears while the user is scrolling.
    ///
    /// See UIScrollView.IndexDisplayMode for possible values.
    func indexDisplayMode(_ mode: UIScrollView.IndexDisplayMode) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateIndexDisplayMode(mode)))
        return view
    }
    /// A Boolean value that determines whether the scroll view delays the handling of touch-down gestures.
    ///
    /// If the value of this property is true, the scroll view delays handling the touch-down gesture until it can determine if scrolling is the intent. If the value is false , the scroll view immediately calls touchesShouldBegin(_:with:in:). The default value is true.
    /// See the class description for a fuller discussion.
    func delaysContentTouches(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateDelaysContentTouches(state)))
        return view
    }
    /// A Boolean value that controls whether touches in the content view always lead to tracking.
    ///
    /// If the value of this property is true and a view in the content has begun tracking a finger touching it, and if the user drags the finger enough to initiate a scroll, the view receives a touchesCancelled(_:with:) message and the scroll view handles the touch as a scroll. If the value of this property is false, the scroll view doesn’t scroll regardless of finger movement once the content view starts tracking.
    func canCancelContentTouches(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateCanCancelContentTouches(state)))
        return view
    }
    /// A floating-point value that specifies the minimum scale factor that can apply to the scroll view’s content.
    ///
    /// This value determines how small the content can be scaled. The default value is 1.0.
    func minimumZoomScale(_ scale: CGFloat) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateMinimumZoomScale(scale)))
        return view
    }
    /// A floating-point value that specifies the maximum scale factor that can apply to the scroll view’s content.
    ///
    /// This value determines how large the content can be scaled. It must be greater than the minimum zoom scale for zooming to be enabled. The default value is 1.0.
    func maximumZoomScale(_ scale: CGFloat) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateMaximumZoomScale(scale)))
        return view
    }
    /// A floating-point value that specifies the current scale factor applied to the scroll view’s content.
    ///
    /// This value determines how much the content is currently scaled. The default value is 1.0.
    func zoomScale(_ scale: CGFloat) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateZoomScale(scale)))
        return view
    }
    /// A Boolean value that determines whether the scroll view animates the content scaling when the scaling exceeds the maximum or minimum limits.
    ///
    /// If the value of this property is true and zooming exceeds either the maximum or minimum limits for scaling, the scroll view temporarily animates the content scaling just past these limits before returning to them. If this property is false, zooming stops immediately at one a scaling limits. The default value is true.
    func bouncesZoom(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateBouncesZoom(state)))
        return view
    }
    /// A Boolean value that controls whether the scroll-to-top gesture is enabled.
    ///
    /// The scroll-to-top gesture is a tap on the status bar. When a user makes this gesture, the system asks the scroll view closest to the status bar to scroll to the top. If that scroll view has scrollsToTop set to false, its delegate returns false from scrollViewShouldScrollToTop(_:), or the content is already at the top, nothing happens.
    ///
    /// After the scroll view scrolls to the top of the content view, it sends the delegate a scrollViewDidScrollToTop(_:) message.
    ///
    /// The default value of this property is true.
    func scrollsToTop(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateScrollsToTop(state)))
        return view
    }
    /// The manner in which the system dismisses the keyboard when a drag begins in the scroll view.
    ///
    /// The default value is UIScrollView.KeyboardDismissMode.none. See UIScrollView.KeyboardDismissMode for possible values.
    func keyboardDismissMode(_ state: UIScrollView.KeyboardDismissMode) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateKeyboardDismissMode(state)))
        return view
        
    }
    /// The refresh control associated with the scroll view.
    func refreshControl(_ refreshControl: UIRefreshControl) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateRefreshControl(refreshControl)))
        return view
    }
    /// A Boolean value that determines whether the scroll view allows scrolling its content with hardware keyboard input.
    ///
    /// When this value is true, the scroll view animates its content offset in response to input from hardware keyboard keys like Page Up, Page Down, Home, End, and the arrow keys. The scroll view needs to have focus or be first responder to receive these key events.
    ///
    /// The default value is true for apps that link against iOS 17 and later. Set this value to false to disable the ability to scroll content with hardware keyboard keys.
    @available(iOS 17.0, *)
    func allowsKeyboardScrolling(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateScrollViewState(.updateAllowsKeyboardScrolling(state)))
        return view
    }
}
