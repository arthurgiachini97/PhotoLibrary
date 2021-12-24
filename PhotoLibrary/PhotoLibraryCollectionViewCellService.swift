//
//  PhotoLibraryCollectionViewCellService.swift
//  PhotoLibrary
//
//  Created by Arthur Giachini on 01/03/21.
//  Copyright © 2021 Arthur Giachini. All rights reserved.
//

import Alamofire
import RxSwift
import UIKit

protocol PhotoLibraryCollectionViewCellServiceProtocol {
    func storeImage(urlString: String, img: UIImage)
    func downloadImage(urlString: String) -> Observable<UIImage>
    func getPhotosURL(photoId: String) -> Observable<String>
}

class PhotoLibraryCollectionViewCellService: PhotoLibraryCollectionViewCellServiceProtocol {
    
    func storeImage(urlString: String, img: UIImage) {
        let path = NSTemporaryDirectory().appending(UUID().uuidString)
        let url = URL(fileURLWithPath: path)
        
        let data = img.jpegData(compressionQuality: 0.5)
        try? data?.write(to: url)
        
        var dict = (UserDefaults.standard.object(forKey: "ImageCache") as? [String: String]) ?? [String: String]()
        if dict[urlString] == nil {
            dict[urlString] = path
            UserDefaults.standard.set(dict, forKey: "ImageCache")
        }
    }
    
    func downloadImage(urlString: String) -> Observable<UIImage> {
        
        return Observable<UIImage>.create { (observer) -> Disposable in
        
            if let dict = (UserDefaults.standard.object(forKey: "ImageCache") as? [String: String]) {
                if let path = dict[urlString] {
                    if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                        if let img = UIImage(data: data) {
                            observer.onNext(img)
                            return Disposables.create {
                                AF.cancelAllRequests()
                            }
                        }
                    }
                }
            }
            
            AF.download(urlString).responseData { data in
                switch data.result {
                case let .success(data):
                    if let image = UIImage(data: data) {
                        self.storeImage(urlString: urlString, img: image)
                        observer.onNext(image)
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
    
    func getPhotosURL(photoId: String) -> Observable<String> {
        
        return Observable<String>.create { (observer) -> Disposable in
            
            let url = "https://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=f9cc014fa76b098f9e82f1c288379ea1&photo_id=\(photoId)&format=json&nojsoncallback=1"
            
            AF.request(url).responseDecodable(of: PhotoSizes.self) { response in
                switch response.result {
                case let .success(data):
                    for size in data.sizes.size {
                        if size.label == "Large Square" {
                            observer.onNext(size.source)
                            print(size.source)
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
}
