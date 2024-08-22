//
//  ContentView.swift
//  GabTextViewDemo
//
//  Created by Gab on 2024/07/26.
//

import SwiftUI

import GabTextView

struct ContentView: View {
    @State private var text: String = "dddddsadasdasdasdsdsadsasdas\nsdfsdfssdfsfssd"
    @FocusState private var keyboardState
    
    @State private var textColor: Color = .black
    @State private var id: UUID = UUID()
    
    var body: some View {
        Text("키보드 내려")
            .accessibilityLabel("보이스 기능 입니다. 키보드 내려")
            .accessibilityIdentifier("키보드 내려")
            .onTapGesture {
                keyboardState = false
            }
        
        Text("속성 테스트")
            .accessibilityLabel("보이스 기능 입니다. 속성 변경")
            .accessibilityIdentifier("속성 변경")
            .onTapGesture {
                textColor = .mint
                id = UUID()
            }
        
        TextView(text: $text)
            .changeBackgroundColor(.gray.opacity(0.5))
            .isEditable(true)
            .isSelectable(true)
            .setTextViewAppearanceModel(.default)
            .limitCountAndLine(100, 5)
            .textContainerInset(.zero)
            .lineFragmentPadding(.zero)
            .setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            .textViewConfiguration { textView in
                print("이거 걸려?")
                textView.text = "hi"
                textView.textColor = UIColor(textColor)
                textView.backgroundColor = .white
            }
            .textViewDidBeginEditing { textView in
                print("textView: \(textView)")
                textView.text = "nono"
            }
            .overlayPlaceHolder(.topLeading) {
                Text("Input Message")
                    .foregroundStyle(.black)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .accessibilityIdentifier("GabTextView")
            .focused($keyboardState)
            .id(id)
        
    }
}

#Preview {
    ContentView()
}
