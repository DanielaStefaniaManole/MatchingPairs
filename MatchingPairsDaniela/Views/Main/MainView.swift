//
//  MainView.swift
//  MatchingPairsDaniela
//
//  Created by Daniela Manole on 07.09.2023.
//

import UIKit
import SnapKit

protocol MainViewDelegate: AnyObject {
    func viewDidTapMainButton(view: MainView)
    func viewDidTapBack(view: MainView)
}

class MainView: UIView {
    
    var backButton: UIButton = {
        let button = UIButton()
        button.setTitle(.backToThemes, for: .normal)
        button.setTitleColor(.text, for: .normal)
        button.addTarget(self, action: #selector(tappedBack), for: .touchUpInside)
        return button
    }()
    
    var timerLabel: UILabel = {
        let label = UILabel()
        label.text = .timerStart
        label.font = .titleBold
        label.textColor = .text
        label.textAlignment = .center
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .headerBold
        label.textColor = .text
        label.textAlignment = .center
        return label
    }()
    
    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle
        label.textColor = .text
        label.textAlignment = .center
        return label
    }()

    lazy var cardsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "cardCell")
        return collectionView
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .button
        button.layer.cornerRadius = 10
        button.setTitle(.start, for: .normal)
        button.titleLabel?.font = .subtitle
        button.addTarget(self, action: #selector(tappedStart), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: MainViewDelegate?

    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        setup()
        configureLayout()
    }
    
    private func setup() {
        backgroundColor = .background
        statusLabel.isHidden = true
        scoreLabel.isHidden = true
        cardsCollectionView.backgroundColor = .background
    }
    
    private func configureLayout() {
        addSubview(backButton)
        addSubview(timerLabel)
        addSubview(statusLabel)
        addSubview(scoreLabel)
        addSubview(cardsCollectionView)
        addSubview(startButton)
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        statusLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        cardsCollectionView.snp.makeConstraints {
            $0.top.equalTo(timerLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(cardsCollectionView.snp.bottom).offset(40)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(snp.width).dividedBy(2)
        }
    }
    
    func resetGame() {
        startButton.setTitle(.start, for: .normal)
        cardsCollectionView.reloadData()
        timerLabel.text = .timerStart
        scoreLabel.isHidden = true
        statusLabel.isHidden = true
    }
    
    func endGame(winner: Bool, score: String) {
        startButton.setTitle(.tryAgain, for: .normal)
        scoreLabel.isHidden = false
        statusLabel.isHidden = false
        statusLabel.text = winner ? .won : .lost
        scoreLabel.text = "Score: \(score)"
        cardsCollectionView.isHidden = true
    }
    
    @objc func tappedStart() {
        delegate?.viewDidTapMainButton(view: self)
    }
        
    @objc func tappedBack() {
        delegate?.viewDidTapBack(view: self)
    }
}
