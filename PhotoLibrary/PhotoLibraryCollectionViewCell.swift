//
//  PhotoLibraryCollectionViewCell.swift
//  PhotoLibrary
//
//  Created by Arthur Giachini on 24/02/21.
//  Copyright © 2021 Arthur Giachini. All rights reserved.
//

import Foundation
import UIKit

class PhotoLibraryCollectionViewCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
        
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private functions

    private func setupViews() {
        addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
