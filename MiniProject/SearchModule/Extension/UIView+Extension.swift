//
//  UIView+Extension.swift
//  MiniProject
//
//  Created by reyhan muhammad on 14/08/23.
//

import UIKit

extension UIView {
    var globalFrame: CGRect? {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }
}
