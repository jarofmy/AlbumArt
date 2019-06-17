//
//  CollectionViewController.swift
//  AlbumArt
//
//  Created by Jeremy Van on 2/23/19.
//  Copyright © 2019 Jeremy Van. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, VCFinalDelegate {

    var musicItems: [MusicItem] = []
    var musicViewModels: [MusicViewModel] = []
    var musicFavItems: [MusicViewModel] = []
    let musicService = MusicService()
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        musicService.search(for: "kanye west") { musics, error in
            guard let musics = musics, error == nil else {
                print(error ?? "unknown error")
                return
            }
            self.musicItems = musics
            
            for music in self.musicItems {
                self.musicViewModels.append(MusicViewModel(musicItem: music))
            }
            self.collectionView.reloadData()
        }
    }
    
    func newFav(musicViewModel: MusicViewModel, indexPath: IndexPath) {
        if musicViewModel.isFavorite == true {
            self.musicFavItems.append(musicViewModel)
            musicViewModels[indexPath.row].isFavorite = true
        } else {
            musicViewModels[indexPath.row].isFavorite = false
            print(musicViewModel)
            for (index, item) in musicFavItems.enumerated() {
                if item.musicItem.artworkUrl100 == musicViewModel.musicItem.artworkUrl100 {
                    musicFavItems.remove(at: index)
                }
            }
        }
        self.collectionView.reloadData()
    }

    
    // MARK: - Navigation
    @IBAction func segmentedValueChanged(_ sender: Any) {
        collectionView.reloadData()
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        guard let detailViewController = segue.destination as? DetailViewController else { return }
        guard let selectedCollectionViewCell = sender as? CollectionViewCell else { return }
        guard let selectedIndexPath = collectionView.indexPath(for: selectedCollectionViewCell) else { return }
        if let destination = segue.destination as? DetailViewController {
            destination.delegate = self
        }
        
        let music = musicItems[selectedIndexPath.row]
        detailViewController.music = music
        
        let musicFav = musicViewModels[selectedIndexPath.row]
        
        detailViewController.musicViewModel = musicFav
        detailViewController.musicViewModels = musicViewModels
        detailViewController.selectedIndexPath = selectedIndexPath
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if segmentedControl.selectedSegmentIndex == 0 {
            return musicItems.count
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return musicFavItems.count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCollectionCell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
    
        // Configure the cell
        if segmentedControl.selectedSegmentIndex == 0 {
            let music = musicViewModels[indexPath.row]
            cell.albumImageView.image = music.albumArtwork ?? UIImage(named: "surprisedPikacropped")
            
            // logic to check if user favorite or not
            cell.heartImageView.image = music.isFavorite ? UIImage(named: "heartFilled") : nil
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let music = musicFavItems[indexPath.row]
            //        cell.albumImageView.image = UIImage(named: "surprisedPikacropped")
            cell.albumImageView.image = music.albumArtwork
            
            // need logic to check if user favorite or not
            cell.heartImageView.image = music.isFavorite ? UIImage(named: "heartFilled") : nil
        }

        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard musicViewModels[indexPath.row].albumArtwork == nil else {
            return
        }
        musicService.imageFetch(for: musicItems[indexPath.row].artworkUrl100) { (albumArt, error) in
            guard let albumArt = albumArt, error == nil else {
                return
            }
            self.musicViewModels[indexPath.row].albumArtwork = albumArt
            self.collectionView.reloadItems(at: [indexPath])
        }
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
