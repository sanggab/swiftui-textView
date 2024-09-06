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
    
    @State private var textColor: Color = .black
    @State private var id: UUID = UUID()
    
    @State private var textViewHeight: CGFloat = .zero
    @State private var textCount: Int = .zero
    
    private var randomSentence: [String] = [
        "\n 하이용", "이것은 랜덤 문장", "응", "아니 아니\n",
        "오늘은 목요일", "내일은 금요일", "모래는 토요일", "켄터키 프라이드 아저씨",
        "퇴근"
    ]
    
    @State private var inputBreakMode: TextViewInputBreakMode = .continuousWhiteSpace
    
    var body: some View {
        Text("현재 text count : \(textCount)")
            .accessibilityIdentifier("텍스트 카운트")
        
        HStack {
            Rectangle()
                .fill(.mint)
                .frame(width: 50, height: 50)
                .onTapGesture {
                    print("상갑 logEvent \(#function) inputBreakMode: \(inputBreakMode)")
                    inputBreakMode = .lineWithContinuousWhiteSpace
                }
                .accessibilityIdentifier("lineWithContinuousWhiteSpace 변경")
            
            Rectangle()
                .fill(.orange)
                .frame(width: 50, height: 50)
                .onTapGesture {
                    print("상갑 logEvent \(#function) inputBreakMode: \(inputBreakMode)")
                    inputBreakMode = .continuousWhiteSpace
                }
                .accessibilityIdentifier("continuousWhiteSpace 변경")
            
            Rectangle()
                .fill(.blue)
                .frame(width: 50, height: 50)
                .onTapGesture {
                    text += randomSentence.randomElement() ?? ""
                    print("상갑 logEvent \(#function) text: \(text)")
                }
                .accessibilityIdentifier("Text 변경")
            
            Rectangle()
                .fill(.pink)
                .frame(width: 50, height: 50)
                .onTapGesture {
//                    let newText = text.prefix(1)
//                    text = String(newText)
                    text = "초기화"
                }
                .accessibilityIdentifier("Text 변경")
            
            Rectangle()
                .fill(.purple)
                .frame(width: 50, height: 50)
                .onTapGesture {
                    let newText = text.prefix(5)
                    text = String(newText)
                }
                .accessibilityIdentifier("Prefix 자르기")
            
            Rectangle()
                .fill(.brown)
                .frame(width: 50, height: 50)
                .onTapGesture {
                    text = "  "
                }
                .accessibilityIdentifier("공백 교채")
            
            Rectangle()
                .fill(.teal)
                .frame(width: 50, height: 50)
                .onTapGesture {
                    text = "\n\n"
                }
                .accessibilityIdentifier("줄바꿈 교체")
        }
        
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
            .setTextViewAppearanceModel(.default)
            .limitCountAndLine(100, 5)
            .textContainerInset(.zero)
            .lineFragmentPadding(.zero)
            .controlTextViewDelegate(.automatic)
            .setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            .trimMode(.blankWithWhitespacesAndNewlines)
            .sizeMode(.dynamic)
            .inputBreakMode(inputBreakMode)
            .receiveTextViewHeight { height in
                textViewHeight = height
            }
            .receiveTextCount { count in
                textCount = count
            }
            .overlayPlaceHolder(.topLeading) {
                Text("Input Message")
                    .foregroundStyle(.black)
            }
            .frame(height: textViewHeight)
//            .frame(width: 300)
            .accessibilityIdentifier("GabTextView")
            .focused($keyboardState)
            .id(id)
    }

}

#Preview {
    ContentView()
}
