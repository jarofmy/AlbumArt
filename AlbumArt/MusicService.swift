//
//  MusicService.swift
//  AlbumArt
//
//  Created by Jeremy Van on 2/23/19.
//  Copyright © 2019 Jeremy Van. All rights reserved.
//

import UIKit

class MusicService {
    
    var dataTask: URLSessionDataTask?
    
    private let urlString = "https://itunes.apple.com/search?country=US&media=music&entity=album&limit=100&term="
    
    func search(for searchTerm: String, completion: @escaping ([MusicItem]?, Error?) -> ()) {
        
        let searchTerm = searchTerm.replacingOccurrences(of: " ", with: "%20")
        
        guard let url = URL(string: urlString + searchTerm) else {
            print("invalid url: \(urlString + searchTerm)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
//            print("Status code: \(response.statusCode)")
//            print(String(data: data, encoding: .utf8) ?? "unable to print data")
            
            do {
                let decoder = JSONDecoder()
                let musicResult = try decoder.decode(MusicResult.self, from: data)
                DispatchQueue.main.async { completion(musicResult.results, nil) }
            } catch (let error) {
                
                DispatchQueue.main.async { completion(nil, error) }
                
            }
        }
        task.resume()
    }
    
    func imageFetch(for searchTerm: String?, completion: @escaping (UIImage?, Error?) -> ()) {
        guard let searchTerm = searchTerm, let url = URL(string: searchTerm) else {
            print("Invalid image url")
            return
        }
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
//            print("Status code: \(response.statusCode)")
//            print(String(data: data, encoding: .utf8) ?? "unable to print data")
            
            guard let albumArt = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            DispatchQueue.main.async { completion(albumArt, nil) }
        }
        task.resume()
    }
}

