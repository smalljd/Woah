//
//  HMAccessory+Woah.swift
//  Woah
//
//  Created by Jeff on 10/2/16.
//  Copyright © 2016 Jeff Small. All rights reserved.
//

import Foundation
import HomeKit

typealias CharacteristicValues = (LightCharacteristic, Any)

extension HMAccessory {
    func update(characteristic: LightCharacteristic, with value: Any, and completionBlock: (() -> Void)? = nil) {
        guard services.count > 1 else {
            print("This accessory is not user interactable.")
            return
        }
        
        services[1].characteristics[characteristic.index()].writeValue(value) { error in
            if let error = error {
                print("Error writing to light: \(error)")
            }
            
            if let completionBlock = completionBlock {
                completionBlock()
            }
        }
    }
    
    func update(values: [CharacteristicValues], with completionBlock: (() -> Void)? = nil) {
        guard services.count > 1 else {
            print("This accessory is not user interactable.")
            return
        }
        
        var completionsHandled = 0
        
        for (characteristic, value) in values {
            self.services[1].characteristics[characteristic.index()].writeValue(value) { error in
                if let error = error {
                    print("Error updating the \(characteristic) value: \(error)")
                }
                completionsHandled += 1
                
                // Wait until all characteristics have finished updating to run the completion block.
                // This is pretty hacky, better solution would probably involve semaphores and whatnot.
                if completionsHandled == values.count, let completionBlock = completionBlock {
                    completionBlock()
                }
            }
        }
    }
    
    func value(of characteristic: LightCharacteristic) -> Any? {
        guard services.count > 1 else {
            print("This accessory is not user interactable.")
            return nil
        }
        
        return services[1].characteristics[characteristic.index()].value
    }
}
