# CHANGELOG

-----

## [2.0 - GabTextView Cataclysmic patch](https://github.com/sanggab/swiftui-textView/releases/tag/2.0) (2024-09-30)
* 이제 UITextView의 옵션들을 Modifier로 만나보실 수 있습니다. ex) isScrollEnabled, isEditable, setContentCompressionResistancePriority ...
  
* 키보드의 Text를 입력할 때 개행, 공백등 입력을 막는 기능 inputBreakMode()를 추가했습니다.
  
* 키보드의 공백이나 개행을 제거하는 trimMode()를 추가했습니다.
  
* UITextView의 옵션들을 직접 설정을 할 수 있는 textViewConfiguration()를 추가했습니다.
  
* UITextViewDelegate를 받을 수 있는 controlTextViewDelegate()를 추가했습니다.
  * TextViewDelegateMode에 따라 delegate 대행자를 구현해서 처리할 지, modifier로 받아서 처리할 지, 시스템에서 설정한 방식대로 처리할 지 결정합니다.

* UITextView의 height을 알려주는 receiveTextViewHeight()를 추가했습니다.

* UITextView의 text count를 알려주는 receiveTextCount()를 추가했습니다.
  * trimMode()에 영향을 받습니다.
 
*    

---


## [1.0 - GabTextView](https://github.com/sanggab/swiftui-textView/releases/tag/1.0) (2024-08-09)
* SwiftUI 전용 TextView인 GabTextView를 소개합니다!   
* GabTextView는 점차 필요한 기능들을 추가할 예정입니다.   
* 현재로선 간단한 backgroundColor나 UITextView의 특정 options들, placeHolder, 키보드 focus / noneFocus시의 appearance   
  textView의 textCount와 numberOfline 제한(limit) 기능들을 제공합니다!

---

## [0.0 - swiftui-textview beta](https://github.com/sanggab/swiftui-textView/releases/tag/0.0) (2024-07-26)
* 개발 시작!
