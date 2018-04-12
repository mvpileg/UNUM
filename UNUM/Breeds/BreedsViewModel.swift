//
//  BreedsViewModel.swift
//  UNUM
//
//  Created by Matthew Pileggi on 4/11/18.
//  Copyright © 2018 Matthew Pileggi. All rights reserved.
//

import UIKit

struct Breed {
    let name: String
    var image: UIImage?
}

protocol BreedsAvailableDelegate {
    func breedsAvailable()
    func imageAvailable(atIndex index: Int)
}

class BreedsViewModel {
    
    private var breeds: [Breed]
    var delegate: BreedsAvailableDelegate?
    
    init() {
        breeds = [Breed]()
    }
    
    var rowCount: Int {
        return breeds.count
    }
    
    func getModelData(forIndex index: Int) -> (String, UIImage?) {
        let image = breeds[index].image
        
        if image == nil {
            getImageForBreed(at: index)
        }
        return (breeds[index].name, breeds[index].image)
    }
    
    func getBreeds() {
        NetworkManager.shared.getAllBreeds { response, error in
            if let response = response {
                self.breeds = response.breeds.map { Breed(name: $0, image: nil) }
                self.delegate?.breedsAvailable()
            }
        }
    }
    
    private func getImageForBreed(at index: Int) {
        NetworkManager.shared.getRandomImageURL(forBreed: breeds[index].name) { response, error in
            guard let url = response?.message else {
                return
            }
            NetworkManager.shared.downloadImage(at: url) { image, error in
                self.breeds[index].image = image
                if image != nil {
                    self.delegate?.imageAvailable(atIndex: index)
                }
            }
        }
    }
    
}
