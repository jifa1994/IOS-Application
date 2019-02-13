//
//  landmarkTableViewCell.swift
//  MetroExplorer
//
//  Created by Jiahe ZHAO on 11/27/18.
//  Copyright © 2018 Jiahe ZHAO. All rights reserved.
//

import UIKit

class landmarkTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var landmarkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
