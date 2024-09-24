//
//  Model.swift
//  GabTextView
//
//  Created by Gab on 2024/07/30.
//

import SwiftUI

@frozen
public enum TextAppearanceType {
    case focus
    case noneFocus
}

@frozen
public struct TextAppearance: Equatable {
    public static let noneFocus = TextAppearance(font: .boldSystemFont(ofSize: 15), color: .gray)
    public static let focus = TextAppearance(font: .boldSystemFont(ofSize: 15), color: .black)
    
    public var font: UIFont
    public var color: Color
    
    public init(font: UIFont, color: Color) {
        self.font = font
        self.color = color
    }
}

@frozen
public struct TextViewAppearanceModel: Equatable {
    public static let `default` = TextViewAppearanceModel(noneFocus: .noneFocus, focus: .focus)
    
    public var noneFocus: TextAppearance
    public var focus: TextAppearance
    
    public init(noneFocus: TextAppearance,
                focus: TextAppearance) {
        self.noneFocus = noneFocus
        self.focus = focus
    }
}

@frozen
public enum ContentPriorityType {
    case hugging
    case compressionResistance
}

@frozen
public struct ContentPriorityModel: Equatable {
    public static let `default` = ContentPriorityModel(priority: .defaultHigh, axis: .horizontal)
    
    public var priority: UILayoutPriority
    public var axis: NSLayoutConstraint.Axis
    
    public init(priority: UILayoutPriority,
                axis: NSLayoutConstraint.Axis) {
        self.priority = priority
        self.axis = axis
    }
}

@frozen
public struct TextViewContentPriority: Equatable {
    public var hugging: ContentPriorityModel?
    public var compressionResistance: ContentPriorityModel?
    
    public init(hugging: ContentPriorityModel? = nil,
                compressionResistance: ContentPriorityModel? = nil) {
        self.hugging = hugging
        self.compressionResistance = compressionResistance
    }
}

/// TextViewDelegate 처리 Mode
@frozen
public enum TextViewDelegateMode: Equatable {
    /// configuration을 이용해서 직접 delegate 처리
    case none
    /// modifier로 구현된 것으로 받아서 처리
    case modifier
    /// 시스템 방식대로 처리
    case automatic
}

/// TextView Size Mode
@frozen
public enum TextViewSizeMode: Equatable {
    /// 고정
    case fixed
    /// 동적
    case dynamic
}
/// TextView의 Trim 처리 모드
@frozen
public enum TextViewTrimMode {
    /// default
    case none
    /// trim의 whitespaces과 같다
    case whitespaces
    /// trim의 whitespacesAndNewlines과 같다
    case whitespacesAndNewlines
    /// 문자열 사이의 공백과 whitespaces 제거
    case blankWithWhitespaces
    /// 문자열 사이의 공백과 whitespacesAndNewlines 제거
    case blankWithWhitespacesAndNewlines
}
/// TextView의 입력 모드를 케이스에 따라 막는 모드
@frozen
public enum TextViewInputBreakMode {
    /// 기본
    case none
    /// 개행의 입력을 막는다
    case lineBreak
    /// 공백의 입력을 막는다
    case whiteSpace
    /// 연속된 공백의 입력을 막는다
    case continuousWhiteSpace
    /// 개행과 공백의 입력을 막는다
    case lineWithWhiteSpace
    /// 개행과 연속된 공백의 입력을 막는다
    case lineWithContinuousWhiteSpace
}
/// TextView의 ReassembleMode
///
/// 외부의 State에서 변경을 시키면 그것을 감지해서 inputBreak랑 trim을 적용시킬지 말지 정한다.
//@frozen
//public enum TextViewReassembleMode {
//    /// 기본
//    case none
//    /// 입력모드
//    case inputBreak
//    /// 트림
//    case trim
//    /// inputBreak & trim
//    case all
//}
