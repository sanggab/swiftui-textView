//
//  ConfigurationTextView.swift
//  GabTextViewDemo
//
//  Created by Gab on 2/3/25.
//

import SwiftUI
import GabTextView

struct ConfigurationTextView: View {
    @State private var text: String = ""
    
    var body: some View {
        TextView(text: $text)
            .textViewConfiguration({ textView in
                textView.font = .boldSystemFont(ofSize: 20)
                textView.textColor = .gray
                textView.backgroundColor = .systemMint
                textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
                textView.textContainerInset = .zero
                textView.textContainer.lineFragmentPadding = .zero
            })
//            .backgroundColor(color: .mint)
//            .setContentHuggingPriority(.defaultLow, for: .horizontal)
//            .textContainerInset(.zero)
//            .lineFragmentPadding(.zero)
            .limitLine(1)
            .frame(width: 300, height: 300)
    }
}

#Preview {
    ConfigurationTextView()
}
