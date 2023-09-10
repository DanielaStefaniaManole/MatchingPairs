//
//  ViewController.swift
//  MatchingPairsDaniela
//
//  Created by Daniela Manole on 07.09.2023.
//

import UIKit

class MainVC: UIViewController, MainViewDelegate {
    
    private var theme: Theme
    private var cardSymbols: [String] = []
    private var isGameFinished = false
    private var isUserPlaying = false
    private var previousIndexPath = IndexPath()
    private var layout = UICollectionViewFlowLayout()
    weak var timer: Timer?
    private var numberOfSeconds = 45
    private var numberOfTries = 0
    private var numberOfMatches = 0 {
        didSet {
            if numberOfMatches == cardSymbols.count {
                endGame(winner: true)
            }
        }
    }
    
    private let contentView = MainView()
    
    init(theme: Theme) {
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cardSymbols = (theme.symbols + theme.symbols).shuffled()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.delegate = self
        contentView.cardsCollectionView.delegate = self
        contentView.cardsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        if let flowLayout = contentView.cardsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let numberOfItemsPerRow: CGFloat = 5
            let spacingBetweenItems: CGFloat = 1
            let totalSpacing = (numberOfItemsPerRow - 1) * spacingBetweenItems
            let itemWidth = (contentView.cardsCollectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
            flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        }
    }
    
    func viewDidTapMain(view: MainView) {
        if isGameFinished { // player finished the game
            resetGame()
            isGameFinished = false
            contentView.cardsCollectionView.isHidden = false
        } else if isUserPlaying { // player resets the game without finishing
            resetGame()
        } else { // player starts the game
            contentView.startButton.setTitle(.reset, for: .normal)
            isUserPlaying = !isUserPlaying
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            }
            contentView.cardsCollectionView.reloadData()
        }
    }
    
    @objc func updateTimer() {
        numberOfSeconds -= 1
        let secondsString = String(format: "%02i", numberOfSeconds)
        contentView.timerLabel.text = "Time left: 00:\(secondsString)"
        if numberOfSeconds == 0 {
            timer?.invalidate()
            endGame(winner: false)
        }
    }
    
    func resetGame() {
        contentView.startButton.setTitle(.start, for: .normal)
        isUserPlaying = false
        previousIndexPath = IndexPath()
        cardSymbols.shuffle()
        contentView.cardsCollectionView.reloadData()
        timer?.invalidate()
        contentView.timerLabel.text = .timerStart
        contentView.scoreLabel.isHidden = true
        contentView.statusLabel.isHidden = true
        numberOfTries = 0
        numberOfMatches = 0
        numberOfSeconds = 45
    }
    
    func endGame(winner: Bool) {
        contentView.startButton.setTitle(.tryAgain, for: .normal)
        contentView.scoreLabel.isHidden = false
        contentView.statusLabel.isHidden = false
        contentView.statusLabel.text = winner ? .won : .lost
        contentView.scoreLabel.text = "Score: \(calculateScore())"
        timer?.invalidate()
        isUserPlaying = false
        isGameFinished = true
        contentView.cardsCollectionView.isHidden = true
    }
    
    func calculateScore() -> String {
        let timeScore = ((45 - numberOfSeconds) / 45) * 20 // 20%
        let triesScore = 30 / (numberOfTries - cardSymbols.count + 1) // 30%
        let matchScore = (numberOfMatches / cardSymbols.count) * 50 // 50%
        
        return String(timeScore + triesScore + matchScore)
    }
    
    func viewDidTapBack(view: MainView) {
        dismiss(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardSymbols.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contentView.cardsCollectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCell
        cell.configure(frontSymbol: cardSymbols[indexPath.item],
                       backSymbol: theme.cardSymbol,
                       backgroundColor: theme.cardColor.getColor())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isUserPlaying { // cards can't be selected if the player didn't press start
            if indexPath != previousIndexPath {
                numberOfTries += 1
            }
            
            let currentCard = collectionView.cellForItem(at: indexPath) as? CardCell
            currentCard?.flip { [weak self] _ in
                guard let self = self else { return }
                if self.numberOfTries % 2 == 0 {
                    let previousCard = collectionView.cellForItem(at: self.previousIndexPath) as? CardCell
                    if currentCard?.frontSymbol == previousCard?.frontSymbol {
                        previousCard?.match()
                        currentCard?.match()
                        self.numberOfMatches += 2
                    } else {
                        previousCard?.flip()
                        currentCard?.flip()
                    }
                }
                self.previousIndexPath = indexPath
            }
        }
    }
}
