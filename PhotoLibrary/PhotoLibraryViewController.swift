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
    
    private let customView = PhotoLibraryView()
    
    override func loadView() {
        super.loadView()
        view = customView
    }
}
