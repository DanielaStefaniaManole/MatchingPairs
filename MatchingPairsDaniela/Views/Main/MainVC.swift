//
//  ViewController.swift
//  MatchingPairsDaniela
//
//  Created by Daniela Manole on 07.09.2023.
//

import UIKit
import MPServices

class MainVC: UIViewController, MainViewDelegate {
    
    private var theme: Theme
    weak var timer: Timer?
    private var cardSymbols: [String] = []
    private var isGameFinished = false
    private var isUserPlaying = false
    private var previousIndexPath = IndexPath()
    private var layout = UICollectionViewFlowLayout()
    private var numberOfSeconds = 45
    private var numberOfTries = 0
    private var numberOfMatches = 0
    
    private var isPhone = UIDevice.current.userInterfaceIdiom == .phone
    private var isLandscape = UIDevice.current.orientation.isLandscape
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
    
    override func viewDidLayoutSubviews() { // calculate card cell size
        if let flowLayout = contentView.cardsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            var numberOfItemsPerRow = 0
            let width = contentView.cardsCollectionView.bounds.width
            let height = contentView.cardsCollectionView.bounds.height
            
            if isPhone {
                if width > height {
                    numberOfItemsPerRow = 5
                } else {
                    numberOfItemsPerRow = 3
                }
            } else {
                if width > height {
                    numberOfItemsPerRow = 4
                } else {
                    numberOfItemsPerRow = 3
                }
            }
            
            let numberOfItemsPerColumn: Int = cardSymbols.count / numberOfItemsPerRow
            var itemSize = width / CGFloat(numberOfItemsPerRow + 1)
            
            if width > height {
                itemSize = height / CGFloat(numberOfItemsPerColumn + 1)
            }
        
            flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        }
    }
    
    func viewDidTapMainButton(view: MainView) {
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
        contentView.resetGame()
        isUserPlaying = false
        previousIndexPath = IndexPath()
        cardSymbols.shuffle()
        timer?.invalidate()
        numberOfTries = 0
        numberOfMatches = 0
        numberOfSeconds = 45
    }
    
    func endGame(winner: Bool) {
        contentView.endGame(winner: winner, score: computeScore())
        timer?.invalidate()
        isUserPlaying = false
        isGameFinished = true
    }
    
    func computeScore() -> String {
        let score = MPServices.computeScore(numberOfSeconds: numberOfSeconds,
                                            numberOfTries: numberOfTries,
                                            numberOfMatches: numberOfMatches,
                                            numberOfCards: cardSymbols.count)
        return String(score)
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
                        if numberOfMatches == cardSymbols.count {
                            endGame(winner: true)
                        }
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
