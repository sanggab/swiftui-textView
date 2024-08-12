//
//  GabTextView + Modifier.swift
//  GabTextView
//
//  Created by Gab on 2024/08/09.
//

import UIKit
import SwiftUI

// MARK: - Style
public extension TextView {
    /// TextView가 키보드가 focus / noneFocus 시에 font랑 Color를 지정합니다.
    func setTextViewAppearanceModel(_ config: TextViewAppearanceModel = .default) -> TextView {
        let view = self
        view.viewModel.action(.style(.updateTextViewAppearanceModel(config)))
        return view
    }
    
    func setFocusAppearance(_ config: TextAppearance = .focus) -> TextView {
        let view = self
        view.viewModel.action(.style(.updateTextAppearance(.focus, config)))
        return view
    }
    
    func setNoneFocusAppearance(_ config: TextAppearance = .noneFocus) -> TextView {
        let view = self
        view.viewModel.action(.style(.updateTextAppearance(.noneFocus, config)))
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
        view.viewModel.action(.style(.updateLimitCount(count)))
        return view
    }
    /// TextView의 text line의 제한을 지정합니다.
    ///
    /// 기본적으로 최대 제한은 999,999로 지정되어 있습니다.
    func limitLine(_ line: Int) -> TextView {
        let view = self
        view.viewModel.action(.style(.updateLimitLine(line)))
        return view
    }
    /// TextView의 text count와 line의 제한을 지정합니다.
    ///
    /// 기본적으로 최대 제한은 999,999로 지정되어 있습니다.
    func limitCountAndLine(_ count: Int, _ line: Int) -> TextView {
        let view = self
        view.viewModel.action(.style(.updateLimitCount(count)))
        view.viewModel.action(.style(.updateLimitLine(line)))
        return view
    }
}

// MARK: - PlaceHolder
public extension TextView {
    /// TextView에 PlaceHolder를 올립니다.
    ///
    /// text가 0이하인 경우에만 PlaceHolder가 보이고, 아닐 경우에는 EmptyView가 보입니다.
    @ViewBuilder
    func overlayPlaceHolder<V>(_ alignment: Alignment = .center, @ViewBuilder content: @escaping () -> V) -> some View where V: View {
        if #available(iOS 15.0, *) {
            self.overlay(alignment: alignment) {
                makePlaceHolderView(content: content)
            }
        } else {
            self.overlay(makePlaceHolderView(content: content), alignment: alignment)
        }
    }
}

// MARK: - Helper
private extension TextView {
    /// PlaceHolder가 text의 count가 0이하면, content를 보여주고 터치 이벤트를 위해 allowsHitTesting(false)로 세팅한다.
    @ViewBuilder
    func makePlaceHolderView<V>(@ViewBuilder content: @escaping () -> V) -> some View where V: View {
        if self.text.count <= 0 {
            content()
                .allowsHitTesting(false)
        } else {
            EmptyView()
        }
    }
    
}
