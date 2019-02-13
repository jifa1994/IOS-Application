//
//  PersistenceManager.swift
//  MetroExplorer
//
//  Created by Jiahe ZHAO on 11/24/18.
//  Copyright © 2018 Jiahe ZHAO. All rights reserved.
//

import Foundation

class PersistenceManager{
    
    let landmarksKey = "landmarks"
    
    static let sharedInstance = PersistenceManager()
    
    
    func saveLandmarks(landmark: Businesses){
        let userDefaults = UserDefaults.standard
        
        var landmarks = fetchLandmarks()
        landmarks.append(landmark)
        let encoder = JSONEncoder()
        let encodedLandmarks = try? encoder.encode(landmarks)
        
        userDefaults.set(encodedLandmarks, forKey: landmarksKey)
    }
    
    func fetchLandmarks() -> [Businesses]{
        let userDefaults = UserDefaults.standard
        if let landmarkData = userDefaults.data(forKey: landmarksKey), let landmarks = try? JSONDecoder().decode([Businesses].self, from: landmarkData){
            return landmarks
        }
        else{
            return [Businesses]()
        }
    }
    
    // Remove selected landmark
    func removeLandmarks(landmark: Businesses) {
        let userDefaults = UserDefaults.standard
        
        var landmarks = fetchLandmarks()
        for i in 0..<landmarks.count {
            if landmarks[i].id == landmark.id {
                landmarks.remove(at: i)
                break
            }
        }
        let encoder = JSONEncoder()
        let encodedLandmarks = try? encoder.encode(landmarks)
        
        userDefaults.set(encodedLandmarks, forKey: landmarksKey)
    }
    
    // check if selected landmark in persistencemanger
    func inList(landmark: Businesses) -> Bool {
        var landmarks = fetchLandmarks()
        for i in 0..<landmarks.count {
            if landmarks[i].id == landmark.id {
                return true
            }
        }
        return false
    }
}
