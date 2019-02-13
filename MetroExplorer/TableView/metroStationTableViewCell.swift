//
//  metroStationTableViewCell.swift
//  MetroExplorer
//
//  Created by Jiahe ZHAO on 11/26/18.
//  Copyright © 2018 Jiahe ZHAO. All rights reserved.
//

import UIKit

class metroStationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lineCode1: UILabel!
    @IBOutlet weak var lineCode2: UILabel!
    @IBOutlet weak var lineCode3: UILabel!
    @IBOutlet weak var lineCode4: UILabel!
    
    @IBOutlet weak var metroStationName: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
