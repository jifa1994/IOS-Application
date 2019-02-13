//
//  WMATAModel.swift
//  MetroExplorer
//
//  Created by Jiahe ZHAO on 11/25/18.
//  Copyright © 2018 Jiahe ZHAO. All rights reserved.
//

import Foundation

struct WMATAModel: Codable {
    let Stations: [Station]
}

struct Station: Codable {
    let Code: String
    let Name: String
    let StationTogether1: String
    let StationTogether2: String
    let LineCode1: String
    let LineCode2: String?
    let LineCode3: String?
    let LineCode4: String?
    let Lat: Double
    let Lon: Double
    let Address: Address
}

struct Address: Codable {
    let Street: String?
    let City: String?
    let State: String?
    let Zip: String?
}
