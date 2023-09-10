//
//  IntroView.swift
//  MatchingPairsDaniela
//
//  Created by Daniela Manole on 09.09.2023.
//

import UIKit
import SnapKit

protocol IntroViewDelegate: AnyObject {
    func viewDidTapPlay(view: IntroView)
    func viewDidTapChangeTheme(view: IntroView)
}

class IntroView: UIView {
    
    lazy var selectThemeLabel: UILabel = {
        let label = UILabel()
        label.text = .selectTheme
        label.font = .subheader
        label.textColor = .button
        label.textAlignment = .center
        return label
    }()
    
    lazy var changeThemeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .background
        button.layer.borderColor = UIColor.button.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 20
        button.setTitle("*", for: .normal)
        button.setTitleColor(.button, for: .normal)
        button.titleLabel?.font = .subheader
        button.addTarget(self, action: #selector(tappedChangeTheme), for: .touchUpInside)
        return button
    }()
    
    lazy var changeThemeLabel: UILabel = {
        let label = UILabel()
        label.text = .default
        label.textColor = .button
        label.font = .titleBold
        label.textAlignment = .center
        return label
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .button
        button.layer.cornerRadius = 10
        button.setTitle(.play, for: .normal)
        button.titleLabel?.font = .subtitle
        button.addTarget(self, action: #selector(tappedPlay), for: .touchUpInside)
        return button
    }()
    
    private var isPhone = UIDevice.current.userInterfaceIdiom == .phone
    private var changeThemeButtonConstraint = 0
    
    weak var delegate: IntroViewDelegate?
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        setup()
        setupConstraints()
        configureLayout()
    }
    
    private func setup() {
        backgroundColor = .text
    }
    
    private func setupConstraints() {
        changeThemeButtonConstraint = isPhone ? 70 : 100
    }
    
    private func configureLayout() {
        addSubview(selectThemeLabel)
        addSubview(changeThemeButton)
        addSubview(changeThemeLabel)
        addSubview(playButton)
        
        selectThemeLabel.snp.makeConstraints {
            $0.bottom.equalTo(changeThemeButton.snp.top).offset(-10)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        changeThemeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(changeThemeButtonConstraint)
        }
        
        changeThemeLabel.snp.makeConstraints {
            $0.top.equalTo(changeThemeButton.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        playButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(snp.width).dividedBy(2)
        }
    }
    
    @objc func tappedChangeTheme() {
        delegate?.viewDidTapChangeTheme(view: self)
    }
    
    @objc func tappedPlay() {
        delegate?.viewDidTapPlay(view: self)
    }
    
    func configureTheme(theme: Theme) {
        changeThemeButton.setTitle(theme.cardSymbol, for: .normal)
        changeThemeLabel.text = theme.title
        backgroundColor = theme.cardColor.getColor()
    }
}
