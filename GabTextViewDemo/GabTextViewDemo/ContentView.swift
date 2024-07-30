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
    
    var body: some View {
        Text("112323")
        
        TextView(text: $text)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.black)
        
    }
}

#Preview {
    ContentView()
}
