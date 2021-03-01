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

protocol PhotoLibraryCollectionViewCellViewModelProtocol {
    var isLoading: Driver<Bool> { get }
    var downloadedImage: Driver<UIImage> { get }
}

class PhotoLibraryCollectionViewCellViewModel: PhotoLibraryCollectionViewCellViewModelProtocol {
    
    let isLoading: Driver<Bool>
    let downloadedImage: Driver<UIImage>
    
    init(service: PhotoLibraryCollectionViewCellServiceProtocol = PhotoLibraryCollectionViewCellService(), photoId: String) {
        
        let _isLoading = PublishSubject<Bool>()
        isLoading = _isLoading.asDriver(onErrorRecover: { _ in return Driver.empty() })
        
        let url = service
            .getPhotosURL(photoId: photoId)
            .do(onSubscribe: {
                _isLoading.onNext(true)
            })
        .asDriver(onErrorRecover: { _ in return Driver.empty() })
        
        downloadedImage = url
            .flatMap({ (url) -> Driver<UIImage> in
                service
                    .downloadImage(url: url)
                    .asDriver(onErrorRecover: { _ in return Driver.empty() })
            })
            .do(onNext: { (_) in _isLoading.onNext(false) })
            .asDriver(onErrorRecover: { _ in return Driver.empty() })
    }
}
