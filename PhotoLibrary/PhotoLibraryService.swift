//
//  PhotoLibraryService.swift
//  PhotoLibrary
//
//  Created by Arthur Giachini on 24/02/21.
//  Copyright © 2021 Arthur Giachini. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import UIKit

protocol PhotoLibraryServiceProtocol {
    func getPhotoList(tag: String) -> Observable<PhotoList>
    func getPhotosURL(photoId: String) -> Observable<String>
    func downloadImage(url: String) -> Observable<UIImage>
}

class PhotoLibraryService: PhotoLibraryServiceProtocol {
    func getPhotoList(tag: String) -> Observable<PhotoList> {
        let url = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=f9cc014fa76b098f9e82f1c288379ea1&tags=\(tag)&page=1&format=json&nojsoncallback=1"
        
        return Observable<PhotoList>.create { observer -> Disposable in
            
            AF.request(url).responseDecodable(of: PhotoList.self) { response in
                switch response.result {
                case let .success(data):
                    observer.onNext(data)
                    break
                case let .failure(error):
                    observer.onError(error)
                    break
                }
            }
            return Disposables.create {
                AF.cancelAllRequests()
            }
        }
    }
    
    func getPhotosURL(photoId: String) -> Observable<String> {
        
        return Observable<String>.create { (observer) -> Disposable in
            
            let url = "https://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=f9cc014fa76b098f9e82f1c288379ea1&photo_id=\(photoId)&format=json&nojsoncallback=1"
            
            AF.request(url).responseDecodable(of: PhotoSizes.self) { response in
                switch response.result {
                case let .success(data):
                    for size in data.sizes.size {
                        if size.label == "Large Square" {
                            observer.onNext(size.source)
                        }
                    }
                    break
                case let .failure(error):
                    observer.onError(error)
                    break
                }
            }
            
            return Disposables.create {
                AF.cancelAllRequests()
            }
        }
        
    }
    
    func downloadImage(url: String) -> Observable<UIImage> {
        return Observable<UIImage>.create { (observer) -> Disposable in
            
            AF.download(url).responseData { (data) in
                switch data.result {
                case let .success(data):
                    observer.onNext(UIImage(data: data)!)
                    break
                case let .failure(error):
                    observer.onError(error)
                    break
                }
            }
            
            return Disposables.create {
                AF.cancelAllRequests()
            }
        }
    }
    
}
