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
            .onTapGesture {
                keyboardState = false
            }
//        
//        TextView(text: $text)
//            .changeBackgroundColor(.gray.opacity(0.5))
//            .isEditable(true)
//            .isSelectable(true)
//            .setInputModel(model: .default)
//            .limitCountAndLine(10, 5)
//            .overlayPlaceHolder(.topLeading) {
//                Text("Input Message")
//            }
//            .frame(height: 50)
//            .frame(maxWidth: .infinity)
//            .focused($keyboardState)
        
        TextView(text: $text)
            .changeBackgroundColor(.gray)
            .overlayPlaceHolder(.topLeading) {
                Text("Input Message!")
            }
            .frame(height: 50)
        
    }
}

#Preview {
    ContentView()
}
