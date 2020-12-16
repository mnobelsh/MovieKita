//
//  UIViewController.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 14/12/20.
//

import UIKit

extension UIViewController {
    
    func handleDismissActiveKeyboard(in view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onSuperviewDidTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onSuperviewDidTap(_ view: UIView) {
        view.endEditing(true)
    }
    
}
