//
//  StationModel.swift
//  MetroExplorer
//
//  Created by Jiahe ZHAO on 11/25/18.
//  Copyright © 2018 Jiahe ZHAO. All rights reserved.
//

import Foundation

struct StationModel: Codable {
    let lon: Double
    let lat: Double
    let name: String
    let lineCode1: String
    let lineCode2: String?
    let lineCode3: String?
    let lineCode4: String?
}
