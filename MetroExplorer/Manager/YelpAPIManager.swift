//
//  YelpAPIManager.swift
//  MetroExplorer
//
//  Created by Jiahe ZHAO on 11/24/18.
//  Copyright © 2018 Jiahe ZHAO. All rights reserved.
//

import Foundation

protocol FetchLandmarksDelegate {
    func landmarksFound(_ businesses: [Businesses])
    func landmarksNotFound()
}

class YelpAPIManager {
    
    let latitude: Double
    let longitude: Double
    
    init(_ latitude: Double,_ longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var delegate: FetchLandmarksDelegate?
    
    func fetchLandmarks() {
                
        var urlComponents = URLComponents(string: "https://api.yelp.com/v3/businesses/search")!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "term", value: "landmark"),
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude))
        ]
        
        let url = urlComponents.url!
        
        var request = URLRequest(url: url)
        request.setValue("key", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            print("Yelp API request complete")
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Yelp response in nil or 200")
                self.delegate?.landmarksNotFound()
                return
            }
            
            guard let data = data else {
                print("Yelp data is nil")
                self.delegate?.landmarksNotFound()
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let yelpModel = try decoder.decode(YelpModel.self, from: data)
                let businesses = yelpModel.businesses

                self.delegate?.landmarksFound(businesses)
                
                
            } catch let error {
                print(error.localizedDescription)
                self.delegate?.landmarksNotFound()
            }
            
        }
        
        print("Yelp API execute request")
        task.resume()
    }
}
