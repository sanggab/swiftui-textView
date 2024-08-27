//
//  GabTextView + Modifier.swift
//  GabTextView
//
//  Created by Gab on 2024/08/09.
//

import UIKit
import SwiftUI

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
    /// Modifier가 아닌 직접 TextView를 구현하고 싶을 때, 사용
    ///
    ///
    func textViewConfiguration(_ configuration: @escaping (UITextView) -> Void) -> TextView {
        var view: TextView = self
        view.viewModel.action(.updateIsConfigurationMode(true))
        view.configuration = configuration
        return view
    }
    /// UITextViewDelegate 처리를 어떻게 할 것 인지 정하는 Modifier
    ///
    /// default값은 automatic
    func controlTextViewDelegate(_ mode: TextViewDelegateMode = .automatic) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateDelegateMode(mode))
        return view
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
