//
//  PhotoLibraryView.swift
//  PhotoLibrary
//
//  Created by Arthur Giachini on 24/02/21.
//  Copyright © 2021 Arthur Giachini. All rights reserved.
//

import Foundation
import UIKit

final class PhotoLibraryView: UIView {
    
    //MARK: Private constants
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        return loadingIndicator
    }()
    
    //MARK: Internal variables
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .white
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(PhotoLibraryCollectionViewCell.self, forCellWithReuseIdentifier: PhotoLibraryCollectionViewCell.description())
        return collectionView
    }()
    
    let emptyStateLabel: UILabel = {
        let emptyStateLabel = UILabel()
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.font = emptyStateLabel.font.withSize(26)
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.textColor = .gray
        return emptyStateLabel
    }()
    
    let errorView = ErrorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(searchBar)
        addSubview(collectionView)
        addSubview(errorView)
        addSubview(loadingIndicator)
        addSubview(emptyStateLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: UIScreen.main.bounds.width * 0.1),
            
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5.0),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5.0),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5.0),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5.0),
            
            errorView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: Internal methods
    
    func showData(_ showData: Bool) {
        collectionView.isHidden = !showData
        errorView.isHidden = showData
    }
    
    func isLoading(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.isHidden = !isLoading
            loadingIndicator.startAnimating()
            collectionView.isHidden = isLoading
            errorView.isHidden = isLoading
            emptyStateLabel.isHidden = isLoading
        } else {
            loadingIndicator.isHidden = isLoading
            loadingIndicator.stopAnimating()
        }
    }
}
