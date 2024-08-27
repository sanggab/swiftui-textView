//
//  GabTextView + ViewStateModifier.swift
//  GabTextView
//
//  Created by Gab on 2024/08/12.
//

import UIKit
import SwiftUI

// MARK: - View State Modifier
public extension TextView {
    /// TextView의 BackgroundColor를 변경합니다.
    ///
    /// 초기 값은 White입니다.
    func changeBackgroundColor(_ color: Color) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateViewState(.updateColor(color)))
        return view
    }
    /// The technique for aligning the text.
    ///
    /// This property applies to the entire text string. The default value of this property is NSTextAlignment.natural.
    ///
    /// Assigning a new value to this property causes the new text alignment to be applied to the entire contents of the text view. If you want to apply the alignment to only a portion of the text, you must create a new attributed string with the desired style information and assign it to the attributedText property.
    func textAlignment(_ alignment: NSTextAlignment) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateViewState(.updateTextAlignment(alignment)))
        return view
    }
    /// A Boolean value that indicates whether the text view is editable.
    ///
    /// The default value of this property is true.
    func isEditable(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateViewState(.updateIsEditable(state)))
        return view
    }
    /// A Boolean value that indicates whether the text view is selectable.
    ///
    /// This property controls the ability of the user to select content and interact with URLs and text attachments. The default value is true.
    func isSelectable(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateViewState(.updateIsSelectable(state)))
        return view
    }
    /// The types of data that convert to tappable URLs in the text view.
    ///
    /// You can use this property to specify the types of data (phone numbers, http links, and so on) that should be automatically converted to URLs in the text view. When tapped, the text view opens the application responsible for handling the URL type and passes it the URL. Note that data detection does not occur if the text view's ``isEditable(_:)`` property is set to true.
    func dataDetectorTypes(_ dataType: UIDataDetectorTypes) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateViewState(.updateDataDetectorTypes(dataType)))
        return view
    }
    /// The inset of the text container's layout area within the text view's content area.
    ///
    /// This property provides text margins for text laid out in the text view. By default the value of this property is (8, 0, 8, 0).
    func textContainerInset(_ edgeInsets: UIEdgeInsets) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateViewState(.updateTextContainerInset(edgeInsets)))
        return view
    }
    /// A Boolean value that determines the rendering scale of the text.
    ///
    /// When the value of this property is true, UIKit automatically adjusts the rendering of the text in the text view to match the standard text scaling.
    ///
    /// When using the standard text scaling, font sizes in the text view appear visually similar to how they would render in macOS and non-Apple platforms, and copying the contents of the text view to the pasteboard preserves the original font point sizes. This effectively changes the display size of the text without changing the actual font point size. For example, text using a 13-point font in iOS looks like text using a 13-point font in macOS.
    ///
    /// If your app is built with Mac Catalyst, or if your text view’s contents save to a document that a user can view in macOS or other platforms, set this property to true.
    ///
    /// The default value of this property is false.
    func usesStandardTextScaling(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateViewState(.updateUsesStandardTextScaling(state)))
        return view
    }
    /// A Boolean value that enables a text view’s built-in find interaction.
    @available(iOS 16.0, *)
    func isFindInteractionEnabled(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateViewState(.updateIsFindInteractionEnabled(state)))
        return view
    }
}
