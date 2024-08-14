//
//  ContentView.swift
//  GabTextViewDemo
//
//  Created by Gab on 2024/07/26.
//

import SwiftUI

import GabTextView

struct ContentView: View {
    @State private var text: String = ""
    @FocusState private var keyboardState
    
    var body: some View {
        Text("키보드 내려")
            .accessibilityLabel("보이스 기능 입니다. 키보드 내려")
            .accessibilityIdentifier("키보드 내려")
            .onTapGesture {
                keyboardState = false
            }
        
//        Button("키보드 내려") {
//            keyboardState = false
//        }
//
        TextView(text: $text)
            .changeBackgroundColor(.gray.opacity(0.5))
            .isEditable(true)
            .isSelectable(true)
            .setTextViewAppearanceModel(.default)
            .limitCountAndLine(10, 5)
            .textContainerInset(.zero)
            .setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            .overlayPlaceHolder(.topLeading) {
                Text("Input Message")
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .accessibilityIdentifier("GabTextView")
            .focused($keyboardState)
            .accessibilityIdentifier(/*@START_MENU_TOKEN@*/"Identifier"/*@END_MENU_TOKEN@*/)
        
    }
}

#Preview {
    ContentView()
}
