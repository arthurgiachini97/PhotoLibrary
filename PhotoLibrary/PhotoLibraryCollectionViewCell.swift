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
    
    private let disposeBag = DisposeBag()
    
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
        viewModel.downloadedImage.drive(onNext: { [photoImageView] image in
            photoImageView.image = image
        })
        .disposed(by: disposeBag)
    }

    // MARK: Private functions

    private func setupViews() {
        layer.masksToBounds =  true
        layer.cornerRadius = 7.5
        addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
