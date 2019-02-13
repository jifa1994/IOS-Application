//
//  WMATAAPIManager.swift
//  MetroExplorer
//
//  Created by Jiahe ZHAO on 11/24/18.
//  Copyright © 2018 Jiahe ZHAO. All rights reserved.
//

import Foundation

protocol FetchMetroStationsDelegate{
    func metroStationsFound(_ stations: [StationModel])
    func metroStationsNotFound(reason: WMATAAPIManager.FailureReason)
}

class WMATAAPIManager{
    
    enum FailureReason: String {
        case noResponse = "No response received"
        case non200Response = "Bad response"
        case noData = "No data recieved"
        case badData = "Bad data"
    }
    
    var delegate: FetchMetroStationsDelegate?
    
    func fetchStations(){
        var urlComponents = URLComponents(string: "https://api.wmata.com/Rail.svc/json/jStations")!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: "key"),
        ]
        
        let url = urlComponents.url!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("WMATA request complete")
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("WMATA No response")
                self.delegate?.metroStationsNotFound(reason: .noResponse)
                return
            }
            
            guard let data = data else {
                print("WAMATA NO Data!")
                self.delegate?.metroStationsNotFound(reason: .noData)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let WMATAResponse = try decoder.decode(WMATAModel.self, from: data)
                
                var stations = [StationModel]()
                
                for station in WMATAResponse.Stations {
                    let lon = station.Lon
                    let lat = station.Lat
                    let name = station.Name
                    let linecode1 = station.LineCode1
                    let linecode2 = station.LineCode2
                    let linecode3 = station.LineCode3
                    let linecode4 = station.LineCode4

                    let s = StationModel(lon: lon, lat: lat, name: name, lineCode1: linecode1, lineCode2: linecode2, lineCode3: linecode3, lineCode4: linecode4)
                    stations.append(s)
                }
                self.delegate?.metroStationsFound(stations)
                
            } catch let error {
                print(error.localizedDescription)
                self.delegate?.metroStationsNotFound(reason: .badData)
            }
            
        }
        print("WMATA execute request")
        task.resume()
    }
}
