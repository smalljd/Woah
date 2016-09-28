//
//  HomeManagerDelegate.swift
//  Woah
//
//  Created by Jeff on 9/27/16.
//  Copyright © 2016 Jeff Small. All rights reserved.
//

import Foundation
import HomeKit

final class HomeManagerDelegate: NSObject, HMHomeManagerDelegate {
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        // Update the UI for homes in all the apps.
    }
}
