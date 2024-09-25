# swiftui-textView

### Requirements
* iOS 14.0+
* Xcode 12.0+
* Swift 5.3


### Content
* [Documentation](#documentation)
* [Modifier](#modifier)
  * [ViewOption](#viewOption)
    * [ChangeBackgroundColor](#changebackgroundcolor)
  * [Style](#style)
    * [Appearance](#appearance)
    * [Limit](#limit)
      * [TextCount](#textcountlimit)
      * [TextLine](#textlintlimit)
  * [PlaceHolder](#placeholder)
  * [Configuration](#configuration)
  * [Delegate](#delegate)
  * [SizeMode](#sizemode)
  * [ReassembleMode](#reassembleMode)
  * [ReceiveTextViewHeight](#receiveTextViewHeight)
  * [ReceiveTextCount](#receiveTextCount)

<a name="documentation"></a>
# Documentation

SwiftUI에서도 TextView를 대체한 TextEditor라는 View가 존재하지만, 이 기능은 실질적으로 UIKit의 TextView를 대체하기엔 너무 부족합니다.   
그래서 이러한 불편함을 해결하기 위해 만든 swiftui-textView를 소개합니다!


<a name="modifier"></a>
# Modifier



<a name="viewOption"></a>
## ViewOption

<a name="changebackgroundcolor"></a>
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

<a name="style"></a>
## Style


<a name="appearance"></a>
### Appearance
* `func setTextViewAppearanceModel(_ config: TextViewAppearanceModel = .default) -> TextView`   
  TextView의 keyboard focus / noneFocus일 때 font하고 textColor를 설정합니다.   

  ##### Usage examples:
  ```swift
  TextView(text: $text)
      .setTextViewAppearanceModel(TextViewAppearanceModel(noneFocus: TextAppearance(font: .boldSystemFont(ofSize: 15),
                                                                                    color: .orange),
                                                          focus: TextAppearance(font: .boldSystemFont(ofSize: 15),
                                                          color: .blue)))
  ```
  <br>

* `func setFocusAppearance(_ config: TextAppearance = .focus) -> TextView`   
  TextView의 focus의 font하고 textColor를 설정합니다.   

  ##### Usage examples:
  ```swift
  TextView(text: $text)
      .setFocusAppearance(TextAppearance(font: .boldSystemFont(ofSize: 15),
                                         color: .blue))
  ```
  <br>
  
* `func setNoneFocusAppearance(_ config: TextAppearance = .noneFocus) -> TextView`   
  TextView의 noneFocus의 font하고 textColor를 설정합니다.   
  
  ##### Usage examples:
  ```swift
  TextView(text: $text)
      .setNoneFocusAppearance(TextAppearance(font: .boldSystemFont(ofSize: 15),
                                             color: .orange))
  ```

  <br>

  
<a name="limit"></a>
### Limit

<a name="textcountlimit"></a>
* `func limitCount(_ count: Int) -> TextView`   
  TextView의 textCount를 제한합니다.   
  default값은 999,999입니다.

    ##### Usage examples:
  ```swift
  TextView(text: $text)
      .limitCount(100)
  ```
  <br>
  
<a name="textlintlimit"></a>
* `func limitLine(_ line: Int) -> TextView`   
  TextView의 line을 제한합니다.   
  default값은 999,999입니다.

    ##### Usage examples:
  ```swift
  TextView(text: $text)
      .limitLine(5)
  ```
  <br>
  

* `func limitCountAndLine(_ count: Int, _ line: Int) -> TextView`    
  TextView의 textCount와 line을 제한합니다.   
  default값은 둘 다 999,999입니다.

  ##### Usage examples:
  ```swift
  TextView(text: $text)
      .limitCountAndLine(100, 5)
  ```
  <br>

<a name="placeholder"></a>
## PlaceHolder

* `@ViewBuilder
  func overlayPlaceHolder<V>(_ alignment: Alignment = .center, @ViewBuilder content: @escaping () -> V) -> some View where V: View`   
  TextView에 PlaceHolder를 세팅합니다.   
  alignment옵션으로 content의 alignment를 설정할 수 있습니다.   
  text의 count가 0이하일 경우에만 content가 노출 되고, 아닐 경우에는 EmptyView()를 리턴합니다.

  ##### Usage examples:
  ```swift
  TextView(text: $text)
      .changeBackgroundColor(.gray)
      .overlayPlaceHolder(.topLeading) {
          Text("Input Message!")
      }
      .frame(height: 50)
  ```

  <img src="doc_img/modifier/overlayPlaceHolder/overlayPlaceHolder.gif"/>


<a name="configuration"></a>
## Configuration

* `func textViewConfiguration(_ configuration: @escaping (UITextView) -> Void) -> TextView`   
  TextView의 옵션을 세팅합니다.   
  configuration의 UITextView에 원하는 옵션들을 설정하면, makeUIView에서 해당 옵션들을 세팅합니다.
  다른 modifier로 옵션들을 설정하는걸 원치 않을 경우에, 해당 modifier를 사용해서 TextView를 구현하면 됩니다.

  ##### Usage examples:
  ```swift
  TextView(text: $text)
    .textViewConfiguration { textView in
        textView.backgroundColor = .gray
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = .zero
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
  ```


<a name="delegate"></a>
## Delegate

<a name="sizemode"></a>
## Sizemode

<a name="reassembleMode"></a>
## ReassembleMode

<a name="receiveTextViewHeight"></a>
## ReceiveTextViewHeight

<a name="receiveTextCount"></a>
## ReceiveTextCount

  <br>
  <br>
  <br>

