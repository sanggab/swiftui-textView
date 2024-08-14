//
//  GabTextView + TextContainerModifier.swift
//  GabTextView
//
//  Created by Gab on 2024/08/14.
//

import SwiftUI

// MARK: - TextContainer State Modifier
public extension TextView {
    /// The value for the text inset within line fragment rectangles.
    ///
    /// The padding appears at the beginning and end of the line fragment rectangles. The layout manager uses this value to determine the layout width. The default value of this property is 5.0.
    /// 
    /// Line fragment padding is not designed to express text margins. Instead, you should use insets on your text view, adjust the paragraph margin attributes, or change the position of the text view within its superview.
    func lineFragmentPadding(_ padding: CGFloat) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateTextContainerState(.updateLlineFragmentPadding(padding)))
        return view
    }
    /// The behavior of the last line inside the text container.
    ///
    /// The NSLineBreakMode constants specify what happens when a line is too long for its container. For example, wrapping can occur on word boundaries (the default) or character boundaries, or the line can be clipped or truncated. The default value of this property is NSLineBreakMode.byWordWrapping.
    func lineBreakMode(_ mode: NSLineBreakMode) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateTextContainerState(.updateLineBreakMode(mode)))
        return view
    }
    
    /// The maximum number of lines that the text container can store.
    ///
    /// The layout manager uses the value of this property to determine the maximum number of lines associated with the text container. The default value of this property is 0, which indicates that there is no limit.
    func maximumNumberOfLines(_ line: Int) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateTextContainerState(.updateMaximumNumberOfLines(line)))
        return view
    }
    /// A Boolean that controls whether the text container adjusts the width of its bounding rectangle when its text view resizes.
    ///
    /// When the value of this property is true, the text container adjusts its width when the width of its text view changes. The default value of this property is false.
    ///
    /// For more information about size tracking, see Text System Storage Layer Overview.
    func widthTracksTextView(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateTextContainerState(.updateWidthTracksTextView(state)))
        return view
    }
    /// A Boolean that controls whether the text container adjusts the height of its bounding rectangle when its text view resizes.
    ///
    /// When the value of this property is true, the text container adjusts its height when the height of its text view changes. The default value of this property is false.
    ///
    /// For more information about size tracking, see Text System Storage Layer Overview.
    func heightTracksTextView(_ state: Bool) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateTextContainerState(.updateHeightTracksTextView(state)))
        return view
    }
}
