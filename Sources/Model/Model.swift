//
//  Model.swift
//  GabTextView
//
//  Created by Gab on 2024/07/30.
//

import SwiftUI

public struct TextStyle: Equatable {
    public static let placeHolder = TextStyle(font: .boldSystemFont(ofSize: 15), color: .gray)
    public static let focus = TextStyle(font: .boldSystemFont(ofSize: 15), color: .black)
    
    public var font: UIFont
    public var color: Color
    
    public init(font: UIFont, color: Color) {
        self.font = font
        self.color = color
    }
}

public struct TextViewInputModel: Equatable {
    public static let `default` = TextViewInputModel(placeHolder: .placeHolder, focus: .focus)
    
    public var placeHolder: TextStyle
    public var focus: TextStyle
    
    public init(placeHolder: TextStyle,
                focus: TextStyle) {
        self.placeHolder = placeHolder
        self.focus = focus
    }
}
