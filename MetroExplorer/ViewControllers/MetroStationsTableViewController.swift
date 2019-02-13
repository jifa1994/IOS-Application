//
//  MetroStationsTableViewController.swift
//  MetroExplorer
//
//  Created by Jiahe ZHAO on 11/26/18.
//  Copyright © 2018 Jiahe ZHAO. All rights reserved.
//

import UIKit
import MBProgressHUD

class MetroStationsTableViewController: UITableViewController {
    
    let wmataAPIManager = WMATAAPIManager()

    var index: Int = 0
    
    var stations = [StationModel](){
        didSet {
            tableView.reloadData()
        }
    }
    
    private func fetchStations(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        wmataAPIManager.fetchStations()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wmataAPIManager.delegate = self
        fetchStations()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "metroStationIdentifier", for: indexPath) as! metroStationTableViewCell
        let station = stations[indexPath.row]
        cell.metroStationName.text = station.name
        cell.lineCode1.textColor = fillColor(station.lineCode1)
        cell.lineCode2.textColor = fillColor(station.lineCode2)
        cell.lineCode3.textColor = fillColor(station.lineCode3)
        cell.lineCode4.textColor = fillColor(station.lineCode4)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        performSegue(withIdentifier: "locationId", sender: indexPath.row)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass the data to your next view controller
        
        if segue.identifier == "locationId" {
            let row = sender as! Int
            let vc = segue.destination as! LandmarksTableViewController
            vc.latitude = stations[row].lat
            vc.longitude = stations[row].lon
            vc.name = stations[row].name
            vc.index = "select"
        }
    }
    
    // This function is used to show the colors of lines
    private func fillColor(_ color: String?) -> UIColor{
        
        if color == "RD" {
            return UIColor.red
        }
        else if color == "OR" {
            return UIColor.orange
        }
        else if color == "BL" {
            return UIColor.blue
        }
        else if color == "YL" {
            return UIColor.yellow
        }
        else if color == "GR" {
            return UIColor.green
        }
        else if color == "SV" {
            return UIColor.gray
        }
        else {
            return UIColor.white
        }
    }

}

extension MetroStationsTableViewController: FetchMetroStationsDelegate {
    func metroStationsFound(_ stations: [StationModel]) {
        print("Stations Found")
        print(stations.count)
        DispatchQueue.main.async {
            self.stations = stations
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func metroStationsNotFound(reason: WMATAAPIManager.FailureReason) {
        print("No stations found")
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            let alertController = UIAlertController(title: "Problem finding metro stations", message: reason.rawValue, preferredStyle: .alert)
            
            switch(reason) {
            case .noResponse:
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                    self.fetchStations()
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
    }
    

}
