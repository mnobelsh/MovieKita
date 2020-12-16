//
//  UIView.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 12/12/20.
//

import UIKit

extension UIView {
    
    enum CornerType {
        case topLeft,
             topRight,
             bottomLeft,
             bottomRight,
             allCorner
    }
    
    func setShadow(withColor color: UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .init(width: 0, height: 0)
    }
    
    func setShadow(withColor color: UIColor, offset: CGSize) {
        self.setShadow(withColor: color)
        self.layer.shadowOffset = offset
    }
    
    func setRoundedCorners(_ corners: [CornerType], withRadius radius: CGFloat) {
        var roundedCorners = [CACornerMask]()
        corners.forEach { corner in
            switch corner {
                case .allCorner:
                    roundedCorners = [
                        .layerMaxXMaxYCorner,
                        .layerMaxXMinYCorner,
                        .layerMinXMaxYCorner,
                        .layerMinXMinYCorner
                    ]
                    break
                case .bottomLeft:
                    roundedCorners.append(.layerMinXMaxYCorner)
                    break
                case .bottomRight:
                    roundedCorners.append(.layerMaxXMaxYCorner)
                    break
                case .topLeft:
                    roundedCorners.append(.layerMinXMinYCorner)
                    break
                case .topRight:
                    roundedCorners.append(.layerMaxXMinYCorner)
                    break
            }
        }
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = CACornerMask(roundedCorners)
    }
    
}
