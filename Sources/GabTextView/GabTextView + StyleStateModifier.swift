//
//  GabTextView + StyleStateModifier.swift
//  GabTextView
//
//  Created by Gab on 2024/08/13.
//

import SwiftUI

// MARK: - Style
public extension TextView {
    /// TextView가 키보드가 focus / noneFocus 시에 font랑 Color를 지정합니다.
    func setTextViewAppearanceModel(_ config: TextViewAppearanceModel = .default) -> TextView {
        let view = self
        view.viewModel.action(.updateStyleState(.updateTextViewAppearanceModel(config)))
        return view
    }
    
    func setFocusAppearance(_ config: TextAppearance = .focus) -> TextView {
        let view = self
        view.viewModel.action(.updateStyleState(.updateTextAppearance(.focus, config)))
        return view
    }
    
    func setNoneFocusAppearance(_ config: TextAppearance = .noneFocus) -> TextView {
        let view = self
        view.viewModel.action(.updateStyleState(.updateTextAppearance(.noneFocus, config)))
        return view
    }
}

// MARK: - Style
public extension TextView {
    /// TextView의 text count의 제한을 지정합니다.
    ///
    /// 기본적으로 최대 제한은 999,999로 지정되어 있습니다.
    func limitCount(_ count: Int) -> TextView {
        let view = self
        view.viewModel.action(.updateStyleState(.updateLimitCount(count)))
        return view
    }
    /// TextView의 text line의 제한을 지정합니다.
    ///
    /// 기본적으로 최대 제한은 999,999로 지정되어 있습니다.
    func limitLine(_ line: Int) -> TextView {
        let view = self
        view.viewModel.action(.updateStyleState(.updateLimitLine(line)))
        return view
    }
    /// TextView의 text count와 line의 제한을 지정합니다.
    ///
    /// 기본적으로 최대 제한은 999,999로 지정되어 있습니다.
    func limitCountAndLine(_ count: Int, _ line: Int) -> TextView {
        let view = self
        view.viewModel.action(.updateStyleState(.updateLimitCount(count)))
        view.viewModel.action(.updateStyleState(.updateLimitLine(line)))
        return view
    }
}
