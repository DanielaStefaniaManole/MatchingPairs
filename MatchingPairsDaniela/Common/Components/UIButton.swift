//
//  UIButton.swift
//  MatchingPairsDaniela
//
//  Created by Daniela Manole on 07.09.2023.
//

import UIKit

extension UIButton {
    
    static func primary(_ title: String? = nil) -> Self {
        let button = UIButton()
        button.backgroundColor = .button
        button.setTitleColor(.background, for: .normal)
        button.layer.cornerRadius = 3.0
        button.titleLabel?.text = title
        
        return button as! Self
    }
}
