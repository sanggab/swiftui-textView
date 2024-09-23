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
    /// TextView의 Size를 고정 / 동적으로 처리할 것 인지 정하는 Modifier
    ///
    /// default값은 fixed
    func sizeMode(_ mode: TextViewSizeMode = .fixed) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateSizeMode(mode))
        return view
    }
    /// TextView에서 입력이 아닌 외부에서 text를 수정할 경우에 textView.text를 적용시킬지 말지 정하는 Modifier
    ///
    /// default값은 none
    func reassembleMode(_ mode: ReassembleMode = .none) -> TextView {
        let view: TextView = self
        view.viewModel.action(.updateReassembleMode(mode))
        return view
    }
    /// TextView의 height을 던져주는 Modifier
    ///
    /// 이 Modifier는 ``sizeMode(_:)``의 ``TextViewSizeMode``에서 dynamic일 때 작동합니다.
    func receiveTextViewHeight(_ height: @escaping ((CGFloat) -> Void)) -> TextView {
        var view: TextView = self
        view.receiveTextViewHeight = height
        return view
    }
    /// TextView의 text count를 던져주는 Modifier
    ///
    /// 이 Modifier는 ``trimMode(_:)``의 ``TextViewTrimMode``에 영향을 받는다.
    func receiveTextCount(_ count: @escaping ((Int) -> Void)) -> TextView {
        var view: TextView = self
        view.receiveTextCount = count
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
