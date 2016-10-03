//
//  LightDataSource.swift
//  Woah
//
//  Created by Jeff on 10/1/16.
//  Copyright © 2016 Jeff Small. All rights reserved.
//

import Foundation
import HomeKit

enum LightCharacteristic: Int {
    case Name
    case PowerState
    case Brightness
    case Saturation
    case Hue
    case ID
    
    func index() -> Int {
        return self.rawValue
    }
    
    func maxValue() -> Float {
        switch self {
        case .Name, .PowerState, .ID:   return 0.00
        case .Brightness:               return 100.00
        case .Saturation:               return 100.00
        case .Hue:                      return 360.00
        }
    }
    
    func minValue() -> Float {
        return 0.00
    }
}

protocol AccessoryCharacteristicWithLimits {
    var min: Float { get }
    var max: Float { get }
    var step: Float { get }
}

protocol AccessoryChangeObserver {
    func lightsUpdated(with accessories: [HMAccessory])
}

struct Lights {
    static var dataSource = Lights()
    
    var lights: [HMAccessory] {
        get {
            guard let home = Home.instance.manager.primaryHome else {
                return []
            }
            
            return home.accessories.filter({
                return $0.services.count > 1
            })
        }

        set {
            notifyObservers()
        }
    }
    
    var observers = [AccessoryChangeObserver]()
    
    private init() {}
    
    mutating func add(observer: AccessoryChangeObserver) {
        observers.append(observer)
    }
    
    func notifyObservers() {
        for observer in observers {
            observer.lightsUpdated(with: lights)
        }
    }
}
