//
//  PhotoLibraryService.swift
//  PhotoLibrary
//
//  Created by Arthur Giachini on 24/02/21.
//  Copyright © 2021 Arthur Giachini. All rights reserved.
//

import Alamofire
import RxSwift
import UIKit

protocol PhotoLibraryServiceProtocol {
    func getPhotoList(tags: String) -> Observable<PhotoList>
}

class PhotoLibraryService: PhotoLibraryServiceProtocol {
    func getPhotoList(tags: String) -> Observable<PhotoList> {
        let url = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=f9cc014fa76b098f9e82f1c288379ea1&tags=\(tags)&page=1&format=json&nojsoncallback=1"
        
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
}
