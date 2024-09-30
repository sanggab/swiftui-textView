# CHANGELOG

-----

## [2.0 - GabTextView Cataclysmic patch](https://github.com/sanggab/swiftui-textView/releases/tag/2.0) (2024-09-30)
#### Add

* 이제 UITextView의 옵션들을 Modifier로 만나보실 수 있습니다. ex) isScrollEnabled, isEditable, setContentCompressionResistancePriority ...
  
  #### InputBreak
  * UITextView에서 Text 입력을 할 때, 공백이나 개행과 관련된 입력을 막아주는 modifier를 추가했습니다.

  ##### Trim
  * UITextView에서 Text의 입력을 마무리 할 때, 공백이나 개행을 제거해주는 modifier를 추가했습니다.

  ##### Configuration
  * UITextView의 옵션들을 modifier가 아닌 직접 설정하게 해주는 modifier를 추가했습니다.
  * 해당 기능으로 UITextView를 구성할 경우에, UITextView의 옵션을 설정해주는 modifier들은 적용이 안됩니다. ( GabTextView만의 modifier들은 적용이 됩니다. )
  
  ##### Delegate
  * UITextViewDelegate를 
  
  ##### ReceiveTextViewHeight
  * UITextView의 height를 받을 수 있는 modifier를 추가했습니다.
  
  ##### ReceiveTextCount
  * UITextView의 text count를 받을 수 있는 modifier를 추가했습니다.
  
  ##### ReassembleMode
  * 키보드의 입력이 아닌 TextView를 구현할 때 생성자 매개변수에 들어가는 @State 객체를 수정해서 UITextView에 update를 시켜주는 modifier를 추가했습니다.

---


## [1.0 - GabTextView](https://github.com/sanggab/swiftui-textView/releases/tag/1.0) (2024-08-09)
* SwiftUI 전용 TextView인 GabTextView를 소개합니다!   
* GabTextView는 점차 필요한 기능들을 추가할 예정입니다.   
* 현재로선 간단한 backgroundColor나 UITextView의 특정 options들, placeHolder, 키보드 focus / noneFocus시의 appearance   
  textView의 textCount와 numberOfline 제한(limit) 기능들을 제공합니다!

---

## [0.0 - swiftui-textview beta](https://github.com/sanggab/swiftui-textView/releases/tag/0.0) (2024-07-26)
* 개발 시작!
