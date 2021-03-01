//
//  PhotoLibraryCollectionViewCellViewModelTests.swift
//  PhotoLibraryTests
//
//  Created by Arthur Giachini on 01/03/21.
//  Copyright © 2021 Arthur Giachini. All rights reserved.
//

import Quick
import Nimble
import RxTest
import RxSwift
import UIKit

@testable import PhotoLibrary

class PhotoLibraryCollectionViewCellViewModelTests: QuickSpec {
    
    private var service: PhotoLibraryCollectionViewCellServiceMock!
    private var sut: PhotoLibraryCollectionViewCellViewModelProtocol!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    override func spec() {
        super.spec()
        
        start()
    }
    
    private func setup(photoListResult: ResultType = .success, downloadImageResult: ResultType = .success) {
        
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        
        service = PhotoLibraryCollectionViewCellServiceMock(photosURLResult: photoListResult, downloadImageResult: downloadImageResult)
        sut = PhotoLibraryCollectionViewCellViewModel(service: service, photoId: "")
    }
    
    private func start() {
        
        describe("PhotoLibraryCollectionViewCellViewModel") {
            
            when("when it is initialized") {
                beforeEach {
                    self.setup()
                    self.scheduler.createHotObservable([.next(300, ())])
                        .bind(to: self.sut.loadData)
                        .disposed(by: self.disposeBag)
                    self.sut.state.drive().disposed(by: self.disposeBag)
                    self.sut.downloadedImage.drive().disposed(by: self.disposeBag)
                }
                
                then("then the request service is called") {
                    let observer = self.scheduler.start({ self.service.getPhotoURLRequestCalled.map { _ in true } })
                    expect(observer.events).to(equal([.next(300, true)]))
                }
                
                then("then the loader appears") {
                    let observer = self.scheduler.start({ self.sut.state })
                    expect(observer.events).to(contain([.next(300, .loading)]))
                }
            }
            
            when("when the service returns") {
                
                given("with error") {
                    
                    beforeEach {
                        self.setup(photoListResult: .error)
                        self.scheduler.createHotObservable([.next(300, ())])
                            .bind(to: self.sut.loadData)
                            .disposed(by: self.disposeBag)
                        self.sut.downloadedImage.drive().disposed(by: self.disposeBag)
                    }
                    
                    then("then the error must be generated") {
                        let observer = self.scheduler.start({ self.sut.state })
                        expect(observer.events).to(equal([.next(300, .loading), .next(300, .error)]))
                    }
                }
                
                given("with data") {
                    
                    beforeEach {
                        self.setup()
                        self.scheduler.createHotObservable([.next(300, ())])
                            .bind(to: self.sut.loadData)
                            .disposed(by: self.disposeBag)
                        self.sut.downloadedImage.drive().disposed(by: self.disposeBag)
                    }
                    
                    then("then the data must be showed") {
                        let observer = self.scheduler.start({ self.sut.state })
                        expect(observer.events).to(equal([.next(300, .loading), .next(300, .data)]))
                    }
                }
            }
            
        }
    }
}


final private class PhotoLibraryCollectionViewCellServiceMock: PhotoLibraryCollectionViewCellServiceProtocol {
    
    let photosURLResult: ResultType
    let downloadImageResult: ResultType
    
    let getPhotoURLRequestCalled = PublishSubject<Void>()
    let downloadImageRequestCalled = PublishSubject<Void>()
    
    init(photosURLResult: ResultType, downloadImageResult: ResultType) {
        self.photosURLResult = photosURLResult
        self.downloadImageResult = downloadImageResult
    }
    
    func getPhotosURL(photoId: String) -> Observable<String> {
        getPhotoURLRequestCalled.onNext(())
        
        switch photosURLResult {
        case .success:
            return Observable.just("https://live.staticflickr.com/31337/50992137593_b5096ca3ed_q.jpg")
        case .error:
            return Observable.error(APIError.generic)
        }
        
    }
    
    func downloadImage(url: String) -> Observable<UIImage> {
        downloadImageRequestCalled.onNext(())
        
        switch downloadImageResult {
        case .success:
            return Observable.just(UIImage())
        case .error:
            return Observable.error(APIError.generic)
        }
    }
}

