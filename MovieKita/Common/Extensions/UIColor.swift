//
//  UIColor.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 11/12/20.
//

import UIKit

extension UIColor {
    
    static var labelColor: UIColor {
        return UIColor(named: ColorName.labelColor) ?? UIColor.black
    }
    
    static var backgroundColor: UIColor {
        return UIColor(named: ColorName.backgroundColor) ?? UIColor.white
    }
    
    static var loadingBackgroundColor: UIColor {
        return UIColor(named: ColorName.loadingBackgroundColor) ?? UIColor.lightGray
    }
    
    static var loadingComponentsColor: UIColor {
        return UIColor(named: ColorName.loadingComponentsColor) ?? UIColor.darkGray
    }
    
    static var barTintColor: UIColor {
        return UIColor(named: ColorName.barTintColor) ?? UIColor.systemBlue
    }
    
    static var cardBackgroundColor: UIColor {
        return UIColor(named: ColorName.cardBackgroundColor) ?? UIColor.gray
    }
    
    static var favoriteIconColor: UIColor {
        return UIColor(named: ColorName.favoriteIconColor) ?? UIColor.systemPink
    }
    
    static var shadowBackgroundColor: UIColor {
        return UIColor(named: ColorName.shadowBackgroundColor) ?? UIColor.gray
    }
}
