//
//  CustomLabel.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 11/12/20.
//

import UIKit

class CustomLabel: UILabel {
    
    enum CustomLabelType {
        case heading1,
             heading2,
             heading3,
             heading4,
             body1,
             body2
            
    }
    
    init(_ text: String, for labelType: CustomLabelType) {
        super.init(frame: .infinite)
        self.text = text
        self.textColor = .labelColor
        self.textAlignment = .left
        switch labelType {
            case .body1:
                self.font = .body1
                break
            case .body2:
                self.font = .body2
                break
            case .heading1:
                self.font = .heading1
                break
            case .heading2:
                self.font = .heading2
                break
            case .heading3:
                self.font = .heading3
                break
            case .heading4:
                self.font = .heading4
                break
        }
        self.numberOfLines = .zero
        self.translatesAutoresizingMaskIntoConstraints = false
        self.adjustsFontSizeToFitWidth = false
        self.minimumScaleFactor = 0.2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
