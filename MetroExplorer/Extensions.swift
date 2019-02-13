//
//  Extensions.swift
//  MetroExplorer
//
//  Created by Jiahe ZHAO on 11/27/18.
//  Copyright © 2018 Jiahe ZHAO. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
