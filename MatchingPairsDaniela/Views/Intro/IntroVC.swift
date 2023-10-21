//
//  IntroVC.swift
//  MatchingPairsDaniela
//
//  Created by Daniela Manole on 09.09.2023.
//

import UIKit

class IntroVC: UIViewController, IntroViewDelegate {

    private let contentView = IntroView()
    private var themes: [Theme] = [Theme()]
    private var selectedThemeIndex = 0
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        loadThemes()
    }
    
    private func loadThemes() {
        APIHandler.getThemes(completion: { [weak self] result in
            switch result {
            case .success(let themes):
                self?.themes += themes
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func viewDidTapPlay(view: IntroView) {
        let mainVC = MainVC(theme: themes[selectedThemeIndex])
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
    }
    
    func viewDidTapChangeTheme(view: IntroView) {
        selectedThemeIndex = ((selectedThemeIndex + 1) % themes.count)
        contentView.configureTheme(theme: themes[selectedThemeIndex])
    }
}
