//
//  PhotoLibraryViewModel.swift
//  PhotoLibrary
//
//  Created by Arthur Giachini on 25/02/21.
//  Copyright © 2021 Arthur Giachini. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PhotoLibraryViewModelProtocol {
    var loadData: PublishSubject<Void> { get }
    var title: Driver<String> { get }
    var cellViewModels: Driver<[PhotoLibraryCollectionViewCellViewModelProtocol]> { get }
}

class PhotoLibraryViewModel: PhotoLibraryViewModelProtocol {
    
    let title = Driver.just("Photo Library")
    
    let loadData = PublishSubject<Void>()
    
    let cellViewModels: Driver<[PhotoLibraryCollectionViewCellViewModelProtocol]>
    
    init(service: PhotoLibraryServiceProtocol = PhotoLibraryService()) {
        let list = loadData.flatMap { _ -> Observable<PhotoList> in
            service.getPhotoList(tag: "kitten")
        }
        
        let photosIds = list.map { list -> [String] in
            var photoIdsList = [String]()
            for i in 0...15 {
                photoIdsList.append(list.photos.photo[i].id)
            }
            return photoIdsList
        }
        
        cellViewModels = photosIds.map { photoIds -> [PhotoLibraryCollectionViewCellViewModelProtocol] in
            var array = [PhotoLibraryCollectionViewCellViewModelProtocol]()
            for photoId in photoIds {
                array.append(PhotoLibraryCollectionViewCellViewModel(photoId: photoId))
            }
            return array
        }
        .asDriver(onErrorRecover: { _ in return Driver.empty() })
    }
}
