//
//  UIView+roundCorners.swift
//  github-user-lookup
//
//  Created by Luiza Collado Garofalo on 11/28/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import UIKit

extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}
