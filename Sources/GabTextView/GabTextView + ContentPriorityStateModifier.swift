//
//  GabTextView + ContentPriorityStateModifier.swift
//  GabTextView
//
//  Created by Gab on 2024/08/13.
//

import SwiftUI

// MARK: - UIView Option
public extension TextView {
    /// Returns the priority with which a view resists being made smaller than its intrinsic size.
    ///
    /// - Parameter priority: The new priority.
    ///
    /// - Parameter axis: The axis for which the content hugging priority should be set.
    ///
    /// Custom views should set default values for both orientations on creation, based on their content, typically to UILayoutPriorityDefaultLow or UILayoutPriorityDefaultHigh. When creating user interfaces, the layout designer can modify these priorities for specific views when the overall layout design requires different tradeoffs than the natural priorities of the views being used in the interface.
    ///
    /// Subclasses should not override this method.
    func setContentHuggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateContentPriorityState(.updateSetContentHuggingPriority(ContentPriorityModel(priority: priority, axis: axis))))
        return view
    }
    /// Sets the priority with which a view resists being made smaller than its intrinsic size.
    ///
    /// - Parameter priority: The new priority.
    ///
    /// - Parameter axis: The axis for which the compression resistance priority should be set.
    ///
    /// Custom views should set default values for both orientations on creation, based on their content, typically to UILayoutPriorityDefaultLow or UILayoutPriorityDefaultHigh. When creating user interfaces, the layout designer can modify these priorities for specific views when the overall layout design requires different tradeoffs than the natural priorities of the views being used in the interface.
    ///
    /// Subclasses should not override this method.
    func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateContentPriorityState(.updateSetContentCompressionResistancePriority(ContentPriorityModel(priority: priority, axis: axis))))
        return view
    }
}
