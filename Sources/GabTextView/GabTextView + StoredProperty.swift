//
//  GabTextView + StoredProperty.swift
//  GabTextView
//
//  Created by Gab on 2024/08/27.
//

import SwiftUI

extension TextView {
    
    var editMenuForTextIn: ((TextViewTypealias.EditMenuForTextIn) -> UIMenu?)? {
        get {
            return _editMenuForTextIn as? ((TextViewTypealias.EditMenuForTextIn) -> UIMenu?)
        } set {
            _editMenuForTextIn = newValue
        }
    }
    
    @available(iOS 16.0, *)
    var willDismissEditMenuWith: ((TextViewTypealias.WillDismissEditMenuWith) -> Void)? {
        get {
            return _willDismissEditMenuWith as? ((TextViewTypealias.WillDismissEditMenuWith) -> Void)
        } set {
            _willDismissEditMenuWith = newValue
        }
    }
    
    @available(iOS 16.0, *)
    var willPresentEditMenuWith: ((TextViewTypealias.WillDismissEditMenuWith) -> Void)? {
        get {
            return _willDismissEditMenuWith as? ((TextViewTypealias.WillDismissEditMenuWith) -> Void)
        } set {
            _willDismissEditMenuWith = newValue
        }
    }
    
    @available(iOS 17.0, *)
    var primaryActionFor: ((TextViewTypealias.PrimaryActionFor) -> UIAction?)? {
        get {
            return _primaryActionFor as? ((TextViewTypealias.PrimaryActionFor) -> UIAction?)
        } set {
            _primaryActionFor = newValue
        }
    }
    
    @available(iOS 17.0, *)
    var menuConfigurationFor: ((TextViewTypealias.MenuConfigurationFor) -> UITextItem.MenuConfiguration?)? {
        get {
            return _menuConfigurationFor as? ((TextViewTypealias.MenuConfigurationFor) -> UITextItem.MenuConfiguration?)
        } set {
            _menuConfigurationFor = newValue
        }
    }
    
    @available(iOS 17.0, *)
    var textItemMenuWillEndFor: ((TextViewTypealias.TextItemMenuWillEndFor) -> Void)? {
        get {
            return _textItemMenuWillEndFor as? ((TextViewTypealias.TextItemMenuWillEndFor) -> Void)
        } set {
            _textItemMenuWillEndFor = newValue
        }
    }
    
    @available(iOS 17.0, *)
    var textItemMenuWillDisplayFor: ((TextViewTypealias.TextItemMenuWillDisplayFor) -> Void)? {
        get {
            return _textItemMenuWillDisplayFor as? ((TextViewTypealias.TextItemMenuWillDisplayFor) -> Void)
        } set {
            _textItemMenuWillDisplayFor = newValue
        }
    }
    
    
}
