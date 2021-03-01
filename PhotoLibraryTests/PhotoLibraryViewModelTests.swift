//
//  PhotoLibraryViewModelTests.swift
//  PhotoLibraryTests
//
//  Created by Arthur Giachini on 28/02/21.
//  Copyright © 2021 Arthur Giachini. All rights reserved.
//

import Quick
import Nimble
import RxTest
import RxSwift
import UIKit

@testable import PhotoLibrary

class PhotoLibraryViewModelTests: QuickSpec {
    
    private var service: PhotoLibraryServiceMock!
    private var sut: PhotoLibraryViewModel!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    override func spec() {
        super.spec()
        
        start()
    }
    
    private func setup() {
        
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        
        service = PhotoLibraryServiceMock()
        sut = PhotoLibraryViewModel(service: service)
    }
    
    private func start() {
        
        describe("PhotoLibraryViewModel") {
            
            when("when the search button is tapped") {
                
                beforeEach {
                    self.setup()
                    self.scheduler.createHotObservable([.next(300, "Kitten")])
                        .bind(to: self.sut.tags)
                        .disposed(by: self.disposeBag)
                    self.sut.cellViewModels.drive().disposed(by: self.disposeBag)
                }
                
                then("then the request service is called") {
                    let observer = self.scheduler.start({ self.service.getPhotoListRequestCalled.map { _ in true } })
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
//                        self.setup(basicDataResult: .failure(error: SDSessionError(.generic)))
//                        self.scheduler.createHotObservable([.next(300, ())])
//                            .bind(to: self.sut.loadData)
//                            .disposed(by: self.disposeBag)
//                        self.sut.statesList.subscribe().disposed(by: self.disposeBag)
                    }
                    
                    then("then the error must be generated") {
//                        let observer = self.scheduler.start({ self.sut.state })
//                        expect(observer.events).to(equal([.next(300, .loading), .next(300, .error(SDSessionError(.generic)))]))
                    }
                }
                
                given("with data") {
                    
                    beforeEach {
                        self.setup()
                        self.scheduler.createHotObservable([.next(300, "Kitten")])
                            .bind(to: self.sut.tags)
                            .disposed(by: self.disposeBag)
                        self.sut.cellViewModels.drive().disposed(by: self.disposeBag)
                    }
                    
                    then("then the data must be showed") {
//                        let observer = self.scheduler.start({ self.sut.state })
//                        expect(observer.events).to(equal([.next(300, .loading), .next(300, .data), .completed(300)]))
                    }
                }
            }
        }
    }
}

private final class PhotoLibraryServiceMock: PhotoLibraryServiceProtocol {
    
    var getPhotoListRequestCalled = PublishSubject<Void>()
    var postCalled = PublishSubject<Void>()
    
    func getPhotoList(tags: String) -> Observable<PhotoList> {
        getPhotoListRequestCalled.onNext(())
        return .empty()
    }
    
    func getPhotosURL(photoId: String) -> Observable<String> {
        return .empty()
    }
    
    func downloadImage(url: String) -> Observable<UIImage> {
        return .empty()
    }
}

func given(_ description: String, flags: FilterFlags = [:], closure: @escaping () -> Void) {
    context(description, flags: flags, closure: closure)
}

func and(_ description: String, flags: FilterFlags = [:], closure: @escaping () -> Void) {
    context(description, flags: flags, closure: closure)
}

func when(_ description: String, flags: FilterFlags = [:], closure: @escaping () -> Void) {
    describe(description, flags: flags, closure: closure)
}

func then(_ description: String, flags: FilterFlags = [:], closure: @escaping () -> Void) {
    it(description, flags: flags, closure: closure)
}


