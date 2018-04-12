//
//  NetworkManager.swift
//  UNUM
//
//  Created by Matthew Pileggi on 4/11/18.
//  Copyright © 2018 Matthew Pileggi. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

struct BreedsResponse: Decodable {
    let status: String
    let breeds: [String]
}

struct RandomImageResponse: Decodable {
    let status: String
    let message: String
}

class NetworkManager {
    
    static let shared = NetworkManager()

    private init() {}
    
    func getAllBreeds(callback: @escaping (BreedsResponse?, String?) -> Void) {
        let url = "https://dog.ceo/api/breeds/list/all"
        request(url: url, callback: callback)
    }
    
    func getRandomImageURL(forBreed breed: String, callback: @escaping (RandomImageResponse?, String?) -> Void) {
        let url = "https://dog.ceo/api/breed/\(breed)/images/random"
        request(url: url, callback: callback)
    }
    
    func downloadImage(at url: String, callback: @escaping (UIImage?, String?) -> Void) {
        print("requesting iamge at", url)
        Alamofire.request(url).responseImage { response in
           callback(response.result.value, response.error?.localizedDescription)
        }
    }
    
    private func request<T: Decodable>(url: String, callback: @escaping (T?, String?) -> Void) {
        Alamofire.request(url).responseJSON { response in
            guard let data = response.data else {
                callback(nil, "no response data")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                callback(response, nil)
            } catch {
                callback(nil, "could not decode")
            }
        }
    }
}

extension BreedsResponse {
    struct DynamicKey: CodingKey {
        var stringValue: String
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        init?(intValue: Int) { return nil }
    }
    
    private enum CodingKeys: String, CodingKey {
        case status
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        
        var mappedBreeds = [String]()
        let breedsContainer = try container.nestedContainer(keyedBy: DynamicKey.self, forKey: .message)
        for key in breedsContainer.allKeys {
            mappedBreeds.append(key.stringValue)
        }
        self.breeds = mappedBreeds
    }
}
