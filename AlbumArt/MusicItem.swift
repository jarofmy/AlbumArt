//
//  MusicItem.swift
//  AlbumArt
//
//  Created by Jeremy Van on 2/23/19.
//  Copyright © 2019 Jeremy Van. All rights reserved.
//

import UIKit

struct MusicResult: Codable {
    let results: [MusicItem]
}


struct MusicItem: Codable {
    let artistName: String?
    let artworkUrl100: String?
    let collectionName: String?
}

struct MusicViewModel {
    let musicItem: MusicItem
    var albumArtwork: UIImage?
    var isFavorite: Bool
    
    init(musicItem: MusicItem) {
        self.musicItem = musicItem
        self.isFavorite = false
    }
}
