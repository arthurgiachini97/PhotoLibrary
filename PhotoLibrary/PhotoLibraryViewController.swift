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
    
    init(viewModel: PhotoLibraryViewModelProtocol = PhotoLibraryViewModel()) {
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
        
        setupBindings()
    }
    
    // MARK: Private methods
    
    private func setupBindings() {
        viewModel.cellViewModels
            .drive(customView.collectionView.rx.items(cellIdentifier: PhotoLibraryCollectionViewCell.description(), cellType: PhotoLibraryCollectionViewCell.self)) { (row, viewModel, cell) in
                cell.configure(viewModel: viewModel)
        }
        .disposed(by: disposeBag)
    }
}
