//
//  GabTextView + StoredProperty.swift
//  GabTextView
//
//  Created by Gab on 2024/08/27.
//

import SwiftUI

extension TextView {
    @available(iOS 16.0, *)
    var willDismissEditMenuWith: ((UITextView, UIEditMenuInteractionAnimating) -> Void)? {
        get {
            return _willDismissEditMenuWith as? ((UITextView, UIEditMenuInteractionAnimating) -> Void)
        } set {
            _willDismissEditMenuWith = newValue
        }
    }
    
    @available(iOS 16.0, *)
    var willPresentEditMenuWith: ((UITextView, UIEditMenuInteractionAnimating) -> Void)? {
        get {
            return _willPresentEditMenuWith as? ((UITextView, UIEditMenuInteractionAnimating) -> Void)
        } set {
            _willPresentEditMenuWith = newValue
        }
    }
    
    @available(iOS 17.0, *)
    var primaryActionFor: ((UITextView, UITextItem, UIAction) -> UIAction?)? {
        get {
            return _primaryActionFor as? ((UITextView, UITextItem, UIAction) -> UIAction?)
        } set {
            _primaryActionFor = newValue
        }
    }
    
    @available(iOS 17.0, *)
    var menuConfigurationFor: ((UITextView, UITextItem, UIMenu) -> UITextItem.MenuConfiguration?)? {
        get {
            return _menuConfigurationFor as? ((UITextView, UITextItem, UIMenu) -> UITextItem.MenuConfiguration?)
        } set {
            _menuConfigurationFor = newValue
        }
    }
    
    @available(iOS 17.0, *)
    var textItemMenuWillEndFor: ((UITextView, UITextItem, UIContextMenuInteractionAnimating) -> Void)? {
        get {
            return _textItemMenuWillEndFor as? ((UITextView, UITextItem, UIContextMenuInteractionAnimating) -> Void)
        } set {
            _textItemMenuWillEndFor = newValue
        }
    }
    
    @available(iOS 17.0, *)
    var textItemMenuWillDisplayFor: ((UITextView, UITextItem, UIContextMenuInteractionAnimating) -> Void)? {
        get {
            return _textItemMenuWillDisplayFor as? ((UITextView, UITextItem, UIContextMenuInteractionAnimating) -> Void)
        } set {
            _textItemMenuWillDisplayFor = newValue
        }
    }
    
    
}
