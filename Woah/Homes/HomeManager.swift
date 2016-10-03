//
//  HomeManagerDelegate.swift
//  Woah
//
//  Created by Jeff on 9/27/16.
//  Copyright © 2016 Jeff Small. All rights reserved.
//

import Foundation
import HomeKit

struct Home {
    
    static let instance = Home()
    
    let manager = HMHomeManager()
    var homes: [HMHome] {
        return manager.homes
    }
    
    lazy var accessories: [HMAccessory] = {
        guard let primaryHome = self.manager.primaryHome else {
            return []
        }
        
        let accessories = primaryHome.accessories
        Lights.dataSource.lights = accessories
        return primaryHome.accessories
    }()
    
    private init() {}
}

final class HomeManagerDelegate: NSObject, HMHomeManagerDelegate {
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        // Update the UI for homes in all the apps.
    }
    
    func homeManager(_ manager: HMHomeManager, didAdd home: HMHome) {
        manager.updatePrimaryHome(home) { error in
            print("Unable to add home \(home.name)")
        }
    }
}
