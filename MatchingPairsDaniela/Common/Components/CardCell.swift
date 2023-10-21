//
//  CardCell.swift
//  MatchingPairsDaniela
//
//  Created by Daniela Manole on 07.09.2023.
//

import UIKit

class CardCell: UICollectionViewCell {

    lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .subheader
        label.textAlignment = .center
        return label
    }()
    
    var frontSymbol = ""
    var backSymbol = ""
    var isFlipped = false
    var isMatched = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        contentView.layer.cornerRadius = 10
    }
    
    private func configureLayout() {
        contentView.addSubview(symbolLabel)
        
        symbolLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.center.equalToSuperview()
        }
    }
    
    func configure(frontSymbol: String, backSymbol: String, backgroundColor: UIColor) {
        self.frontSymbol = frontSymbol
        self.backSymbol = backSymbol
        self.symbolLabel.text = backSymbol
        isMatched = false
        isFlipped = false
        contentView.backgroundColor = backgroundColor
        contentView.isHidden = false
        isUserInteractionEnabled = true
    }
    
    func flip(_ completion: ((Bool) -> Void)? = nil) {
        isFlipped = !isFlipped
        
        if isFlipped {
            symbolLabel.text = frontSymbol
            UIView.transition(with: self,
                              duration: 0.3,
                              options: .transitionFlipFromLeft,
                              animations: nil,
                              completion: completion)
        } else {
            symbolLabel.text = backSymbol
            UIView.transition(with: self,
                              duration: 0.3,
                              options: .transitionFlipFromRight,
                              animations: nil,
                              completion: completion)
        }
    }
    
    func match() {
        isMatched = true
        contentView.isHidden = true
        isUserInteractionEnabled = false
    }
}

