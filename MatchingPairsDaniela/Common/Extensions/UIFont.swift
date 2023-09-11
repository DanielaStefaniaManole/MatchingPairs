//
//  UIFont.swift
//  MatchingPairsDaniela
//
//  Created by Daniela Manole on 10.09.2023.
//

import UIKit

extension UIFont {
    
    static let headerBold = getDevice(fontName: "Helvetica Neue Bold", fontSize: 26.0)
    static let subheader = getDevice(fontSize: 22.0)
    static let titleBold = getDevice(fontName: "Helvetica Neue Bold", fontSize: 18.0)
    static let subtitle = getDevice(fontSize: 16.0)
    
    static func getDevice(fontName: String = "Helvetica Neue", fontSize: CGFloat) -> UIFont? {
        let isPhone = UIDevice.current.userInterfaceIdiom == .phone
        
        return UIFont(name: fontName, size: isPhone ? fontSize : (fontSize + 10.0))
    }
}
