//
//  LocationDetector.swift
//  MetroExplorer
//
//  Created by Jiahe ZHAO on 11/29/18.
//  Copyright © 2018 Jiahe ZHAO. All rights reserved.
//

import Foundation
import CoreLocation
import MBProgressHUD

protocol LocationDetectorDelegate {
    func locationDetected(latitude: Double, longitude: Double)
    func locationNotDetected(reason: LocationDetector.LocationFailReason) //no GPS/network signal for 5 seconds (timeout) OR no permission (TODO: implement timeout)
}

class LocationDetector: NSObject {
    
    
    enum LocationFailReason: String {
        case restricted, denied = "Go to System -> Privacy -> Location"
        case badInternet = "Bad Internet"
    }
    
    
    let locationManager = CLLocationManager()
    
    var delegate: LocationDetectorDelegate?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    func findLocation() {
        let permissionStatus = CLLocationManager.authorizationStatus()
        
        switch(permissionStatus) {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            delegate?.locationNotDetected(reason: .restricted)
        case .denied:
            delegate?.locationNotDetected(reason: .denied)
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        }
    }
}

extension LocationDetector: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //do something with the location
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            
            delegate?.locationDetected(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //handle the error
        print(error.localizedDescription)
        delegate?.locationNotDetected(reason: .badInternet)
    }
    
    //this gets called after user accepts OR denies permission
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //handle this
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
        else {
            delegate?.locationNotDetected(reason: .restricted)
        }
    }
    
}
