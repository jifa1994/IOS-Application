//
//  ViewController.swift
//  MetroExplorer
//
//  Created by Jiahe ZHAO on 11/24/18.
//  Copyright © 2018 Jiahe ZHAO. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreLocation


class ViewController: UIViewController{
    
    var name: String = ""
    var flag = false
    var locationDetector = LocationDetector()
    var currentLat: Double = 0
    var currentLon: Double = 0
    var metroLat: Double = 0
    var metroLon: Double = 0
    var gameTimer: Timer!
    var times = 0
    
    @IBAction func nearestButtonPressed(_ sender: Any) {
        print("Find nearest station button pressed")
        
        if flag {
            performSegue(withIdentifier: "nearestLandmarksIdentifier", sender: self)
        } else {
            let messageVC = UIAlertController(title: "Location Detection", message: "We cannot get access to your current location." , preferredStyle: .actionSheet)
            present(messageVC, animated: true) {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
                    messageVC.dismiss(animated: true, completion: nil)})}
        }

    }
    @IBAction func metroListButtonPressed(_ sender: Any) {
        print("Find metro list button pressed")
        performSegue(withIdentifier: "metroFinderIdentifier", sender: self)
    }
    @IBAction func favoriteLandmarksButtonPressed(_ sender: Any) {
        print("Favorite button pressed")
        performSegue(withIdentifier: "favoriteLandmarksIdentifier", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nearestLandmarksIdentifier" {
            let vc = segue.destination as! LandmarksTableViewController
            vc.latitude = metroLat
            vc.longitude = metroLon
            vc.name = name
            vc.index = "nearest"
            
        } else if segue.identifier == "favoriteLandmarksIdentifier" {
            let vc = segue.destination as! LandmarksTableViewController
            vc.index = "favorite"
        }
    }
    
    // This function is used to detect which metro is closest to current location.
    func findNearestMetro() {
        let wmata = WMATAAPIManager()
        wmata.delegate = self
        wmata.fetchStations()

        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        while times < 10 {
            if flag {
                break
            }
        }
        gameTimer.invalidate()
        MBProgressHUD.hide(for: self.view, animated: true)
        
    }
    
    @objc func runTimedCode(){
        times += 1
        print(times)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationDetector.delegate = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        flag = false
        locationDetector.findLocation()
    }
    
}

extension ViewController: LocationDetectorDelegate, FetchMetroStationsDelegate {
    
    func metroStationsFound(_ stations: [StationModel]) {
        print("stations found")
        if flag {
            var minDistance = Double(INT_MAX)
            for station in stations {
                let distance = pow(currentLat - station.lat, 2) + pow(currentLon - station.lon, 2)
                if distance < minDistance {
                    minDistance = distance
                    metroLat = station.lat
                    metroLon = station.lon
                    name = station.name
                }
            }
            flag = true
        }
    }
    
    func metroStationsNotFound(reason: WMATAAPIManager.FailureReason) {
        flag = false
        let alertController = UIAlertController(title: "Problem finding nearest metro station", message: reason.rawValue, preferredStyle: .alert)
        
        switch(reason) {
        case .noResponse:
            let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                self.findNearestMetro()
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler:nil)
            
            alertController.addAction(cancelAction)
            alertController.addAction(retryAction)
            
        case .non200Response, .noData, .badData:
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler:nil)
            
            alertController.addAction(okayAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }

    func locationDetected(latitude: Double, longitude: Double) {
        currentLat = latitude
        currentLon = longitude
        flag = true
        print("Location Detector Work")
        findNearestMetro()

    }
    
    func locationNotDetected(reason: LocationDetector.LocationFailReason) {
        switch(reason){
        case.restricted :
            print(reason)
        case.denied:
            print(reason)
        case.badInternet:
            print(reason)
        }
        
        flag = false
        
        MBProgressHUD.hide(for: self.view, animated: true)
    }


    
}




