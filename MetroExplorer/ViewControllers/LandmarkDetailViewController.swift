//
//  LandmarkDetailViewController.swift
//  MetroExplorer
//
//  Created by Jiahe ZHAO on 11/24/18.
//  Copyright © 2018 Jiahe ZHAO. All rights reserved.
//

import UIKit
import SafariServices

class LandmarkDetailViewController: UIViewController {
    
    var landmarks: [Businesses] = [Businesses]()
    var currentLat: Double = 0
    var currentLon: Double = 0
    var flag = false

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var detailTitle: UINavigationItem!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var buttonIcon: UIBarButtonItem!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBAction func navigationButtonPressed(_ sender: Any) {
        var address = landmarks[0].name
        address = address.replacingOccurrences(of: " ", with: "%20")
        if UIApplication.shared.canOpenURL(URL(string:"http://maps.apple.com/")!) {
            UIApplication.shared.open(URL(string: "http://maps.apple.com/?daddr=\(address)&dirflg=r")!)
        } else {
            let messageVC = UIAlertController(title: "Navigation Map", message: "The map is currently not working." , preferredStyle: .actionSheet)
            present(messageVC, animated: true) {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
                    messageVC.dismiss(animated: true, completion: nil)})}        }
        
    }
    
    @IBAction func sharedButtonPressed(_ sender: Any) {
        let shareText = "Check out this landmark: \(landmarks[0].name)"
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        let flag = PersistenceManager.sharedInstance.inList(landmark: landmarks[0])
        if flag {
            buttonIcon.image = UIImage(named: "like")
            buttonIcon.tintColor = UIColor.init(displayP3Red: 1, green: 0, blue: 0, alpha: 1)
            PersistenceManager.sharedInstance.removeLandmarks(landmark: landmarks[0])
        }
        else {
            buttonIcon.image = UIImage(named: "like_fill")
            buttonIcon.tintColor = UIColor.init(displayP3Red: 1, green: 0, blue: 0, alpha: 1)
            PersistenceManager.sharedInstance.saveLandmarks(landmark: landmarks[0])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let landmark = landmarks[0]
        detailTitle.title = landmark.name
        fillIsClosedLabel()
        fillAddress()
        loadImage()
        fillRating()
        let flag = PersistenceManager.sharedInstance.inList(landmark: landmark)
        if flag {
            buttonIcon.tintColor = UIColor.init(displayP3Red: 1, green: 0, blue: 0, alpha: 1)
            buttonIcon.image = UIImage(named: "like_fill")
        }
        else{
            buttonIcon.tintColor = UIColor.init(displayP3Red: 1, green: 0, blue: 0, alpha: 1)
            buttonIcon.image = UIImage(named: "like")
        }
    }
    
    // The following functions are used to fill the labels and views
    private func fillIsClosedLabel() {
        let flag = landmarks[0].isClosed
        if flag {
            statusLabel.text = "Currently Closed"
            statusLabel.textColor = UIColor.red
        } else {
            statusLabel.text = "Currently Open"
            statusLabel.textColor = UIColor.green
        }
    }
    
    private func fillAddress() {
        var address: String = ""
        for str in landmarks[0].location.displayAddress {
            address.append(str)
        }
        addressLabel.text = address
    }
    
    private func fillRating() {
        ratingLabel.text = "Rating: \(landmarks[0].rating)"
    }
    
    private func loadImage() {
        let iconUrlString = landmarks[0].imageUrl
        let url = URL(string: iconUrlString)
        detailImageView.load(url: url ?? URL(string: "https://www.freeiconspng.com/uploads/no-image-icon-23.jpg")!)
    }
    
}
