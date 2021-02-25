//
//  PhotoLibraryCoordinator.swift
//  PhotoLibrary
//
//  Created by Arthur Giachini on 25/02/21.
//  Copyright © 2021 Arthur Giachini. All rights reserved.
//

import Foundation
import UIKit

final class PhotoLibraryCoordinator {

    // MARK: Private Properties

    private let navigationController: UINavigationController

    // MARK: Initializers

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = PhotoLibraryViewModel()
        let viewController = PhotoLibraryViewController(with: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
