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
    var downloadedImage: Driver<UIImage> { get }
}

class PhotoLibraryCollectionViewCellViewModel: PhotoLibraryCollectionViewCellViewModelProtocol {
    
    let downloadedImage: Driver<UIImage>
    
    init(service: PhotoLibraryServiceProtocol = PhotoLibraryService(), url: String) {
        
        downloadedImage = service
            .downloadImage(url: url)
            .asDriver(onErrorRecover: { _ in return Driver.empty() })
    }
}
