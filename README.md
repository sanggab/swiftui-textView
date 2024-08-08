# swiftui-textView

### Requirements
* iOS 14.0+
* Xcode 12.0+
* Swift 5.3


### Content
* [Documentation](#documentation)
* [Modifier](#modifier)


<a name="documentation"></a>
# Documentation

SwiftUI에서도 TextView를 대체한 TextEditor라는 View가 존재하지만, 이 기능은 실질적으로 UIKit의 TextView를 대체하기엔 너무 부족합니다.   
그래서 이러한 불편함을 해결하기 위해 만든 swiftui-textView를 소개합니다!


<a name="modifier"></a>
# Modifier

* `func changeBackgroundColor(_ color: Color) -> TextView`   
  TextView의 backgroundColor를 지정합니다.
  TextView의 backgroundColor를 변경하려면 Representable로 구현된 View에 .background() modifier 구현해도 변경되지 않기 때문에, UITextView의 background 옵션을 직접 변경해줘야 합니다.   
  기본 값은 white 입니다.

  ##### Usage examples:
  ```swift
  TextView(text: $text)
      .changeBackgroundColor(.gray)
  ```
  <br>
  

* `func isScrollEnabled(_ state: Bool) -> TextView`   
  TextView의 isScrollEnabled를 설정합니다.   
  default값은 true입니다.

  ##### Usage examples:
  ```swift
  TextView(text: $text)
      .isScrollEnabled(true)
  ```
  <br>
  

* `func isEditable(_ state: Bool) -> TextView`   
  TextView의 isEditable을 설정합니다.   
  default값은 true입니다.

  ##### Usage examples:
  ```swift
  TextView(text: $text)
      .isEditable(true)
  ```
  <br>
  

* `func isSelectable(_ state: Bool) -> TextView`   
  TextView의 isSelectable을 설정합니다.   
  default값은 true입니다.

  ##### Usage examples:
  ```swift
  TextView(text: $text)
      .isSelectable(true)
  ```
  <br>
  

* `func setInputModel(model: TextViewInputModel) -> TextView`   
  TextView의 keyboard focus / noneFocus일 때 font하고 textColor를 설정합니다.

  ##### Usage examples:
  ```swift
  TextView(text: $text)
      .setInputModel(model: TextViewInputModel(noneFocus: TextStyle(font: .boldSystemFont(ofSize: 15),
                                                                    color: .orange),
                                               focus: TextStyle(font: .boldSystemFont(ofSize: 15),
                                                                color: .blue)))
  ```
  <br>

* `@ViewBuilder
  func overlayPlaceHolder<V>(_ alignment: Alignment = .center, @ViewBuilder content: @escaping () -> V) -> some View where V: View`   
  TextView에 PlaceHolder를 세팅합니다.   
  alignment옵션으로 content의 alignment를 설정할 수 있습니다.   
  text의 count가 0이하일 경우에만 content가 노출 되고, 아닐 경우에는 EmptyView()를 리턴합니다.

  ##### Usage examples:
  ```swift
  TextView(text: $text)
      .overlayPlaceHolder(.leading) {
          Text("Input Message!")
      }
  ```
  <br>
  

* `func limitCount(_ count: Int) -> TextView`   
  TextView의 textCount를 제한합니다.   
  default값은 999,999입니다.

    ##### Usage examples:
  ```swift
  TextView(text: $text)
      .changeBackgroundColor(.gray)
  ```
  <br>
  

* `func limitLine(_ line: Int) -> TextView`
  TextView의 line을 제한합니다.   
  default값은 999,999입니다.

    ##### Usage examples:
  ```swift
  TextView(text: $text)
      .changeBackgroundColor(.gray)
  ```
  <br>
  

* `func limitCountAndLine(_ count: Int, _ line: Int) -> TextView`
  TextView의 textCount와 line을 제한합니다.   
  default값은 둘 다 999,999입니다.

  ##### Usage examples:
  ```swift
  TextView(text: $text)
      .changeBackgroundColor(.gray)
  ```
  <br>
  


