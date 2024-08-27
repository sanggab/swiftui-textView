//
//  GabTextView + DelegateModifier.swift
//  GabTextView
//
//  Created by Gab on 2024/08/26.
//

import SwiftUI

public extension TextView {
    
    func textViewShouldBeginEditing(_ textViewShouldBeginEditing: @escaping ((UITextView) -> Bool)) -> TextView {
        var view: TextView = self
        view.textViewShouldBeginEditing = textViewShouldBeginEditing
        return view
    }
    
    func textViewDidBeginEditing(_ textViewDidBeginEditing: @escaping ((UITextView) -> Void)) -> TextView {
        var view: TextView = self
        view.textViewDidBeginEditing = textViewDidBeginEditing
        return view
    }
    
    func textViewDidChange(_ textViewDidChange: @escaping ((UITextView) -> Void)) -> TextView {
        var view: TextView = self
        view.textViewDidChange = textViewDidChange
        return view
    }
    
    func textViewDidChangeSelection(_ textViewDidChangeSelection: @escaping ((UITextView) -> Void)) -> TextView {
        var view: TextView = self
        view.textViewDidChangeSelection = textViewDidChangeSelection
        return view
    }
    
    func textViewShouldEndEditing(_ textViewShouldEndEditing: @escaping ((UITextView) -> Bool)) -> TextView {
        var view: TextView = self
        view.textViewShouldEndEditing = textViewShouldEndEditing
        return view
    }
    
    func textViewDidEndEditing(_ textViewDidBeginEditing: @escaping ((UITextView) -> Void)) -> TextView {
        var view: TextView = self
        view.textViewDidEndEditing = textViewDidEndEditing
        return view
    }
}

public extension TextView {
    
    func editMenuForTextIn(_ editMenuForTextIn: @escaping ((TextViewTypealias.EditMenuForTextIn) -> UIMenu?)) -> TextView {
        var view: TextView = self
        view.editMenuForTextIn = editMenuForTextIn
        return view
    }
    
    @available(iOS 16.0, *)
    func willDismissEditMenuWith(_ willDismissEditMenuWith: @escaping ((TextViewTypealias.WillDismissEditMenuWith) -> Void)) -> TextView {
        var view: TextView = self
        view.willDismissEditMenuWith = willDismissEditMenuWith
        return view
    }
    
    @available(iOS 16.0, *)
    func willPresentEditMenuWith(_ willPresentEditMenuWith: @escaping ((TextViewTypealias.WillPresentEditMenuWith) -> Void)) -> TextView {
        var view: TextView = self
        view.willPresentEditMenuWith = willPresentEditMenuWith
        return view
    }
    
    @available(iOS 17.0, *)
    func primaryActionFor(_ primaryActionFor: @escaping ((TextViewTypealias.PrimaryActionFor) -> UIAction?)) -> TextView {
        var view: TextView = self
        view.primaryActionFor = primaryActionFor
        return view
    }
    
    @available(iOS 17.0, *)
    func menuConfigurationFor(_ menuConfigurationFor: @escaping ((TextViewTypealias.MenuConfigurationFor) -> UITextItem.MenuConfiguration?)) -> TextView {
        var view: TextView = self
        view.menuConfigurationFor = menuConfigurationFor
        return view
    }
    
    @available(iOS 17.0, *)
    func textItemMenuWillEndFor(_ textItemMenuWillEndFor: @escaping ((TextViewTypealias.TextItemMenuWillEndFor) -> Void)) -> TextView {
        var view: TextView = self
        view.textItemMenuWillEndFor = textItemMenuWillEndFor
        return view
    }
    
    @available(iOS 17.0, *)
    func textItemMenuWillDisplayFor(_ textItemMenuWillDisplayFor: @escaping ((TextViewTypealias.TextItemMenuWillDisplayFor) -> Void)) -> TextView {
        var view: TextView = self
        view.textItemMenuWillDisplayFor = textItemMenuWillDisplayFor
        return view
    }
}
