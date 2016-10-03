//
//  AccessoryBrowser.swift
//  Woah
//
//  Created by Jeff on 9/27/16.
//  Copyright © 2016 Jeff Small. All rights reserved.
//

import Foundation
import HomeKit

typealias FindAccessoriesCompletionHandler = (() -> Void)?

final class AccessoryBrowserDelegate: NSObject, HMAccessoryBrowserDelegate {
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        print("Found new accessory: \(accessory.name)")
        print("Category: \(accessory.category.categoryType)")
        print("Accessory bridged: \(accessory.isBridged)")
    }
}
