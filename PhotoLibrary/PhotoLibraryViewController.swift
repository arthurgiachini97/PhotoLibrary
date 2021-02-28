//
//  PhotoLibraryViewController.swift
//  PhotoLibrary
//
//  Created by Arthur Giachini on 24/02/21.
//  Copyright © 2021 Arthur Giachini. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class PhotoLibraryViewController: UIViewController {
    
    // MARK: Private constants
    
    private let customView = PhotoLibraryView()
    
    private let viewModel: PhotoLibraryViewModelProtocol
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializers
    
    init(with viewModel: PhotoLibraryViewModelProtocol = PhotoLibraryViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override methods
    
    override func loadView() {
        super.loadView()
        view = customView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData.onNext(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBindings()
    }
    
    // MARK: Private methods
    
    private func setupBindings() {
        viewModel.title.drive(onNext: { [weak self] title in
            self?.title = title
        })
            .disposed(by: disposeBag)
        
        viewModel.cellViewModels
            .drive(customView.collectionView.rx.items(cellIdentifier: PhotoLibraryCollectionViewCell.description(), cellType: PhotoLibraryCollectionViewCell.self)) { (row, viewModel, cell) in
                cell.configure(viewModel: viewModel)
        }
        .disposed(by: disposeBag)
        
        customView.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.state
            .do(onSubscribe: { [customView] in customView.showData(true) })
            .drive(onNext: { [customView] (state) in
                switch state {
                case .data:
                    customView.isLoading(false)
                    customView.showData(true)
                case .loading:
                    customView.isLoading(true)
                case .error:
                    customView.isLoading(false)
                    customView.showData(false)
                }
            })
            .disposed(by: disposeBag)
        
        Observable.merge(customView.searchBar.rx.searchButtonClicked.map {()},
                         customView.errorView.tryAgainButton.rx.tap.map {()})
            .subscribe(onNext: { [viewModel, customView, view] _ in
                viewModel.tags.onNext(customView.searchBar.text)
                view?.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
}

extension PhotoLibraryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width/2) - 2.5, height: 150)
    }
}
