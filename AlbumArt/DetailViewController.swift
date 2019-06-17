//
//  DetailViewController.swift
//  AlbumArt
//
//  Created by Jeremy Van on 2/23/19.
//  Copyright © 2019 Jeremy Van. All rights reserved.
//

import UIKit

protocol VCFinalDelegate {
    func newFav(musicViewModel: MusicViewModel, indexPath: IndexPath)
}

class DetailViewController: UIViewController {
    
    var music: MusicItem!
    var musicViewModel: MusicViewModel!
    var musicViewModels: [MusicViewModel]!
    var selectedIndexPath: IndexPath!
    var delegate: VCFinalDelegate?

    
    @IBOutlet weak var collectionNameLabel: UILabel! {
        didSet {
            collectionNameLabel.text = music.collectionName
        }
    }
    @IBOutlet weak var artistNameLabel: UILabel! {
        didSet {
            artistNameLabel.text = music.artistName
        }
    }
    @IBOutlet weak var favoriteButton: UIButton! {
        didSet {
            favoriteButton.imageView?.image = musicViewModel.isFavorite ? UIImage(named: "heartFilled") : UIImage(named: "heartEmpty")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        print(musicViewModel.isFavorite)
        if musicViewModel.isFavorite == false {
            musicViewModel.isFavorite = true
            sender.setImage(UIImage(named: "heartFilled"), for: .normal)
        } else {
            musicViewModel.isFavorite = false
            sender.setImage(UIImage(named: "heartEmpty"), for: .normal)
        }
//        print("Do we like this? \(musicViewModel.isFavorite)")
        delegate?.newFav(musicViewModel: musicViewModel, indexPath: selectedIndexPath)

    }

}
