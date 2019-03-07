//
//  UIViewController+hideKeyboardOnTouch.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 7.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardOnTouch() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
