//
//  ErrorView.swift
//  PhotoLibrary
//
//  Created by Arthur Giachini on 26/02/21.
//  Copyright © 2021 Arthur Giachini. All rights reserved.
//

import Foundation
import UIKit

final class ErrorView: UIView {
    
    // MARK: Private constants
    
    private let errorImageView: UIImageView = {
        let errorImageView = UIImageView()
        errorImageView.translatesAutoresizingMaskIntoConstraints = false
        errorImageView.image = UIImage(named: "error")
        return errorImageView
    }()
    
    private let errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.numberOfLines = 0
        errorLabel.font = errorLabel.font.withSize(22)
        errorLabel.textColor = .gray
        errorLabel.textAlignment = .center
        errorLabel.text = "Ops! Something went wrong. Please, try again."
        return errorLabel
    }()
    
    private let height = UIScreen.main.bounds.height
    private let width = UIScreen.main.bounds.width
    
    // MARK: Internal constants
    
    let tryAgainButton: UIButton = {
        let tryAgainButton = UIButton()
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
        tryAgainButton.backgroundColor = #colorLiteral(red: 0.1328099966, green: 0.1328397393, blue: 0.1328060925, alpha: 0.6010098987)
        tryAgainButton.layer.masksToBounds = true
        tryAgainButton.layer.cornerRadius = 10.0
        tryAgainButton.setTitleColor(.white, for: .normal)
        tryAgainButton.setTitle("Try again", for: .normal)
        return tryAgainButton
    }()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func addSubviews() {
        addSubview(errorImageView)
        addSubview(errorLabel)
        addSubview(tryAgainButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            errorImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: height * -0.2),
            errorImageView.heightAnchor.constraint(equalToConstant: height * 0.2),
            errorImageView.widthAnchor.constraint(equalTo: errorImageView.heightAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: height * 0.03),
            errorLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: width * 0.2),
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tryAgainButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: height * 0.03),
            tryAgainButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            tryAgainButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            tryAgainButton.heightAnchor.constraint(equalToConstant: height * 0.06)
        ])
    }
}
