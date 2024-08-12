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
public struct TextViewContentPriority: Equatable {
    public static let `default` = TextViewContentPriority(priority: .defaultLow, axis: .horizontal)
    
    public var priority: UILayoutPriority
    public var axis: NSLayoutConstraint.Axis
    
    public init(priority: UILayoutPriority,
                axis: NSLayoutConstraint.Axis) {
        self.priority = priority
        self.axis = axis
    }
}

@frozen
public struct TextViewOptionModel: Equatable {
    public var isScrollEnabld: Bool = true
    public var isEditable: Bool = true
    public var isSelectable: Bool = true
    public var backgroundColor: Color = .white
    public var contentPriority: TextViewContentPriority = .default
}
