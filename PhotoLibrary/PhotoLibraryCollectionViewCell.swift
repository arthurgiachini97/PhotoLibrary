//
//  PhotoLibraryCollectionViewCell.swift
//  PhotoLibrary
//
//  Created by Arthur Giachini on 24/02/21.
//  Copyright © 2021 Arthur Giachini. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PhotoLibraryCollectionViewCell: UICollectionViewCell {
    
    // MARK: Private constants
    
    private let photoImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        return loadingIndicator
    }()
    
    private let disposeBag = DisposeBag()
    
    private let errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.font = errorLabel.font.withSize(12)
        errorLabel.numberOfLines = 0
        return errorLabel
    }()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
        
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal functions
    
    func configure(viewModel: PhotoLibraryCollectionViewCellViewModelProtocol) {
        viewModel.downloadedImage.drive(onNext: { [photoImageView, loadingIndicator] image in
            loadingIndicator.stopAnimating()
            photoImageView.isHidden = false
            photoImageView.image = image
        })
        .disposed(by: disposeBag)
        
        viewModel.errorText.drive(onNext: { [errorLabel] errorText in
            errorLabel.text = errorText
        })
            .disposed(by: disposeBag)
        
        viewModel.state
            .do(onSubscribe: { [loadingIndicator, photoImageView] in
                photoImageView.isHidden = true
                loadingIndicator.startAnimating()
            })
            .drive(onNext: { [photoImageView, loadingIndicator, errorLabel] state in
                switch state {
                case .data:
                    photoImageView.isHidden = false
                    loadingIndicator.stopAnimating()
                    errorLabel.isHidden = true
                case .loading:
                    photoImageView.isHidden = true
                    loadingIndicator.startAnimating()
                    errorLabel.isHidden = true
                case .error:
                    photoImageView.isHidden = false
                    loadingIndicator.stopAnimating()
                    errorLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.loadData.onNext(())
    }

    // MARK: Private functions

    private func setupViews() {
        layer.masksToBounds =  true
        layer.cornerRadius = 7.5
        addSubview(photoImageView)
        addSubview(loadingIndicator)
        addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
