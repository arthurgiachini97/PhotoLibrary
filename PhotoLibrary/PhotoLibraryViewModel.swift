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

// MARK: - Enum

enum PhotoLibraryViewModelState {
    case data, loading, error
}

// MARK: - Protocol

protocol PhotoLibraryViewModelProtocol {
    var loadData: PublishSubject<Void> { get }
    var tags: PublishSubject<String?> { get }
    var title: Driver<String> { get }
    var cellViewModels: Driver<[PhotoLibraryCollectionViewCellViewModelProtocol]> { get }
    var state: Driver<PhotoLibraryViewModelState> { get }
}

// MARK: - Class

class PhotoLibraryViewModel: PhotoLibraryViewModelProtocol {
    
    let loadData = PublishSubject<Void>()
    
    var tags = PublishSubject<String?>()
    
    let title = Driver.just("Photo Library")
    
    let cellViewModels: Driver<[PhotoLibraryCollectionViewCellViewModelProtocol]>
    
    let state: Driver<PhotoLibraryViewModelState>
    
    init(service: PhotoLibraryServiceProtocol = PhotoLibraryService()) {
        
        let _state = PublishSubject<PhotoLibraryViewModelState>()
        state = _state.asDriver(onErrorRecover: { _ in return Driver.empty() })
        
        let list = tags.compactMap { $0 }
            .flatMap { tags -> Driver<PhotoList> in
                let tagsArray = tags.trimmingCharacters(in: .whitespaces).components(separatedBy: .whitespaces)
                let tagsFormatted = tagsArray.joined(separator: ",")
                
                return service.getPhotoList(tags: tagsFormatted)
                    .do(onNext: { (_) in
                        _state.onNext(.data)
                    }, onError: { (_) in
                        _state.onNext(.error)
                    }, onSubscribe: {
                        _state.onNext(.loading)
                    })
                    .asDriver(onErrorRecover: { _ in return Driver.empty() })
        }
        .asDriver(onErrorRecover: { _ in return Driver.empty() })
        
        let partialPhotosIds = list.filter({ $0.photos.photo.count > 16 }).map { list -> [String] in
            var photoIdsList = [String]()
            for i in 0..<16 {
                photoIdsList.append(list.photos.photo[i].id)
            }
            return photoIdsList
        }
        
        let photosIds = list.filter({ $0.photos.photo.count < 16 }).map { list -> [String] in
            var photoIdsList = [String]()
            for i in 0..<list.photos.photo.count {
                photoIdsList.append(list.photos.photo[i].id)
            }
            return photoIdsList
        }
        
        cellViewModels = Driver.merge(partialPhotosIds, photosIds).map { photoIds -> [PhotoLibraryCollectionViewCellViewModelProtocol] in
            var array = [PhotoLibraryCollectionViewCellViewModelProtocol]()
            for photoId in photoIds {
                array.append(PhotoLibraryCollectionViewCellViewModel(photoId: photoId))
            }
            return array
        }
        .asDriver(onErrorRecover: { _ in return Driver.empty() })
    }
}
