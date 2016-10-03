//
//  LightTableViewCell.swift
//  Woah
//
//  Created by Jeff on 10/1/16.
//  Copyright © 2016 Jeff Small. All rights reserved.
//

import Foundation
import UIKit

typealias LightSwitchAction = (() -> Void)?
typealias ColorButtonAction = (() -> Void)?
typealias DimmerChangeAction = (() -> Void)?

class LightTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lightSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dimmer: UISlider!
    @IBOutlet weak var colorButton: UIButton!
    
    var turnLightOnOrOffAction: LightSwitchAction = nil
    var colorButtonAction: ColorButtonAction = nil
    var dimmerChangeAction: DimmerChangeAction = nil
    
    
    @IBAction func colorButtonTapped(_ sender: AnyObject) {
        guard let action = colorButtonAction else {
            return
        }
        
        // Change the color
        action()
    }
    
    @IBAction func lightSwitchValueChanged(_ sender: UISwitch) {
        guard let action = turnLightOnOrOffAction else {
            return
        }
        action()
    }
    @IBAction func dimmerValueChanged(_ sender: AnyObject, forEvent event: UIEvent) {
        guard let dimmerChangeAction = dimmerChangeAction else {
            return
        }
        
        dimmerChangeAction()
    }
}
