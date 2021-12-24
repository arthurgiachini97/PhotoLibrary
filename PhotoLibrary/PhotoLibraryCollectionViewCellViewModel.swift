//
//  PhotoLibraryCollectionViewCellViewModel.swift
//  PhotoLibrary
//
//  Created by Arthur Giachini on 25/02/21.
//  Copyright © 2021 Arthur Giachini. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

// MARK: - Enum

enum PhotoLibraryCollectionViewCellViewModelState {
    case data, loading, error
}

// MARK: - Protocol

protocol PhotoLibraryCollectionViewCellViewModelProtocol {
    var loadData: PublishSubject<Void> { get }
    var state: Driver<PhotoLibraryCollectionViewCellViewModelState> { get }
    var downloadedImage: Driver<UIImage> { get }
    var errorText: Driver<String> { get }
}

// MARK: - Class

class PhotoLibraryCollectionViewCellViewModel: PhotoLibraryCollectionViewCellViewModelProtocol {
    
    let loadData = PublishSubject<Void>()
    let state: Driver<PhotoLibraryCollectionViewCellViewModelState>
    let downloadedImage: Driver<UIImage>
    let errorText = Driver<String>.just("Could not load this photo.")
    
    init(service: PhotoLibraryCollectionViewCellServiceProtocol = PhotoLibraryCollectionViewCellService(), photoId: String) {
        
        let _state = PublishSubject<PhotoLibraryCollectionViewCellViewModelState>()
        state = _state.asDriver(onErrorRecover: { _ in return Driver.empty() })
        
        let urlString = loadData.flatMap { _ -> Driver<String> in
            service
                .getPhotosURL(photoId: photoId)
                .do(onError: { _ in _state.onNext(.error) },
                    onSubscribe: { _state.onNext(.loading) })
            .asDriver(onErrorRecover: { _ in return Driver.empty() })
        }
        .asDriver(onErrorRecover: { _ in return Driver.empty() })
        
        downloadedImage = urlString
            .flatMap({ (urlString) -> Driver<UIImage> in
                service
                    .downloadImage(urlString: urlString)
                    .do(onNext: { _ in _state.onNext(.data) })
                    .asDriver(onErrorRecover: { _ in return Driver.empty() })
            })
            .asDriver(onErrorRecover: { _ in return Driver.empty() })
    }
}
