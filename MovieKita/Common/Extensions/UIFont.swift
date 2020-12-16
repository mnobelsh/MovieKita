//
//  UIFont.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 11/12/20.
//

import UIKit

extension UIFont {
    
    static var heading1: UIFont {
        return UIFont(name: FontName.karlaSemiBold, size: 30) ?? UIFont.boldSystemFont(ofSize: 30)
    }
    
    static var heading2: UIFont {
        return UIFont(name: FontName.karlaSemiBold, size: 24) ?? UIFont.boldSystemFont(ofSize: 24)
    }
    
    static var heading3: UIFont {
        return UIFont(name: FontName.karlaSemiBold, size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
    }
    
    static var heading4: UIFont {
        return UIFont(name: FontName.karlaSemiBold, size: 14) ?? UIFont.boldSystemFont(ofSize: 14)
    }
    
    static var body1: UIFont {
        return UIFont(name: FontName.loraRegular, size: 16) ?? UIFont.systemFont(ofSize: 16)
    }
    
    static var body2: UIFont {
        return UIFont(name: FontName.loraRegular, size: 12) ?? UIFont.systemFont(ofSize: 12)
    }
    
}
