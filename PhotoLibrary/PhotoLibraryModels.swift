//
//  PhotoLibraryModel.swift
//  PhotoLibrary
//
//  Created by Arthur Giachini on 24/02/21.
//  Copyright © 2021 Arthur Giachini. All rights reserved.
//

import Foundation

struct PhotoList: Decodable {
    
    struct PhotoId: Decodable {
        let id: String
    }
    
    struct PhotoDetails: Decodable {
        let photo: [PhotoId]
    }
    
    let photos: PhotoDetails
}

struct PhotoSizes: Decodable {
    
    struct PhotoURL: Decodable {
        let label: String
        let source: String
    }
    
    struct Size: Decodable {
        let size: [PhotoURL]
    }
    
    let sizes: Size
}
