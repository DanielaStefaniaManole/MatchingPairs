//
//  Theme.swift
//  MatchingPairsDaniela
//
//  Created by Daniela Manole on 07.09.2023.
//

import UIKit

struct Theme: Decodable {
    let cardColor: ThemeColor
    let cardSymbol: String
    let symbols: [String]
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case cardColor = "card_color"
        case cardSymbol = "card_symbol"
        case symbols
        case title
    }
    
    init(cardColor: ThemeColor = ThemeColor(blue: 0.616, green: 0.482, red: 0.271),
         cardSymbol: String = "*",
         symbols: [String] =  ["@", "#", "$", "%"],
         title: String = .default) {
        self.cardColor = cardColor
        self.cardSymbol = cardSymbol
        self.symbols = symbols
        self.title = title
    }
}

struct ThemeColor: Decodable {
    let blue: Float
    let green: Float
    let red: Float
    
    func getColor() -> UIColor {
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
    }
}
