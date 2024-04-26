//
//  UIButton+.swift
//  Animation
//
//  Created by 오연서 on 4/26/24.
//

import UIKit

extension UIButton {
    func shakeButton() {
        self.transform = CGAffineTransform(translationX: 0, y: 20)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 1,
                       options: [.curveEaseInOut]) {
            self.transform = .identity
        }
    }
}
