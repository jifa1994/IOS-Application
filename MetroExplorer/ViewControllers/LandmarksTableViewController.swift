//
//  LandmarksTableViewController.swift
//  MetroExplorer
//
//  Created by Jiahe ZHAO on 11/26/18.
//  Copyright © 2018 Jiahe ZHAO. All rights reserved.
//

import UIKit
import MBProgressHUD

class LandmarksTableViewController: UITableViewController {
    
    var latitude: Double = 0
    var longitude: Double = 0

    var flag = false
    var name: String = ""
    var index: String = ""
    var businesses = [Businesses](){
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var landmarksTitle: UINavigationItem!
    @IBAction func refreshButtonPressed(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if index == "favorite" {
            businesses = PersistenceManager.sharedInstance.fetchLandmarks()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        else {
            let yelpAPIManager = YelpAPIManager(latitude, longitude)
            yelpAPIManager.delegate = self
            yelpAPIManager.fetchLandmarks()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Station seleced: ", name)
        print(latitude, longitude)
        print(index)
        if index == "select" || index == "nearest" {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            landmarksTitle.title = "Landmarks Near \(name)"
            let yelpAPIManager = YelpAPIManager(latitude, longitude)
            yelpAPIManager.delegate = self
            yelpAPIManager.fetchLandmarks()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if 10 < businesses.count {
            return 10
        }
        return businesses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "landmarkIdentifier", for: indexPath) as! landmarkTableViewCell
        let business = businesses[indexPath.row]
        cell.nameLabel.text = business.name
        var address: String = ""
        for str in business.location.displayAddress {
            address.append(str)
        }
        
        cell.addressLabel.text = address
        let iconUrlString = business.imageUrl
        let url = URL(string: iconUrlString)
        cell.landmarkImageView.load(url: url ?? URL(string: "https://www.freeiconspng.com/uploads/no-image-icon-23.jpg")!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailIdentifier", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass the data to your next view controller
        
        if segue.identifier == "detailIdentifier" {
            let row = sender as! Int
            let vc = segue.destination as! LandmarkDetailViewController
            vc.landmarks.append(businesses[row])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if index == "favorite" {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            landmarksTitle.title = "My Favorite"
            businesses = PersistenceManager.sharedInstance.fetchLandmarks()
            MBProgressHUD.hide(for: self.view, animated: true)
            if businesses.count == 0 {
                let messageVC = UIAlertController(title: "No Favorite Landmarks", message: "" , preferredStyle: .actionSheet)
                present(messageVC, animated: true) {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
                        messageVC.dismiss(animated: true, completion: nil)})}            }
        }
    }
 

}

extension LandmarksTableViewController: FetchLandmarksDelegate {

    func landmarksFound(_ businesses: [Businesses]) {
        print("Landmarks Found")
        print(businesses.count)
        DispatchQueue.main.async {
            self.businesses = businesses.shuffled()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func landmarksNotFound() {
        print("No landmarks found")
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
}
