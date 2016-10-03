//
//  ViewController.swift
//  Woah
//
//  Created by Jeff on 9/27/16.
//  Copyright © 2016 Jeff Small. All rights reserved.
//

import UIKit
import HomeKit

class LightsViewController: UIViewController {

    @IBOutlet weak var modalSpinner: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var onOff = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        Lights.dataSource.add(observer: self)
    }
    
    @IBAction func partyButtonTapped(_ sender: AnyObject) {
        tableView.reloadData()
    }
}

extension LightsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Lights.dataSource.lights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.light.rawValue) as? LightTableViewCell else {
            return UITableViewCell()
        }
        
        let light = Lights.dataSource.lights[indexPath.row]
        
        // Color Button
        guard let hue = light.value(of: .Hue) as? Float,
            let brightness = light.value(of: .Brightness) as? Float,
            let saturation = light.value(of: .Saturation) as? Float else
        {
            print("Could not retrieve the color attributes for the light.")
            return UITableViewCell()
        }
        
        cell.colorButton.backgroundColor = UIColor(hue: CGFloat(hue) / CGFloat(LightCharacteristic.Hue.maxValue()),
                                                   saturation: CGFloat(saturation) / CGFloat(LightCharacteristic.Saturation.maxValue()),
                                                   brightness: CGFloat(brightness) / CGFloat(LightCharacteristic.Brightness.maxValue()),
                                                   alpha: 1.0)
        cell.colorButton.layer.borderWidth = 1.0
        cell.colorButton.layer.borderColor = UIColor.black.cgColor
        cell.colorButton.layer.cornerRadius = 5.0
        
        cell.colorButtonAction = {
            let newHue = (hue + 30).truncatingRemainder(dividingBy: 360.0)
            let updatedColors: [CharacteristicValues] = [
                (.Hue, newHue),
                (.Saturation, saturation),
                (.Brightness, brightness),
                ]
            
            light.update(values: updatedColors) {
                Lights.dataSource.notifyObservers()
            }
        }

        // Light switch
        cell.lightSwitch.isOn = (light.value(of: .PowerState) as? Bool) ?? false
        cell.turnLightOnOrOffAction = {
            let values: [CharacteristicValues] = [
                (.PowerState, cell.lightSwitch.isOn),
                (.Brightness, Int(brightness)),
                (.Hue, hue),
                (.Saturation, saturation),
            ]
            
            light.update(values: values)
        }
        
        cell.titleLabel.text = (light.value(of: .Name) as? String) ?? "Light"
        
        // Dimmer
        cell.dimmer.minimumValue = LightCharacteristic.Brightness.minValue()
        cell.dimmer.maximumValue = LightCharacteristic.Brightness.maxValue()
        cell.dimmer.isContinuous = false
        cell.dimmer.setValue(brightness, animated: false)
        
        cell.dimmerChangeAction = {
            light.update(characteristic: .Brightness, with: Int(cell.dimmer.value)) {
                Lights.dataSource.notifyObservers()
            }
        }
        
        
        return cell
    }
}

extension LightsViewController: AccessoryChangeObserver {
    func lightsUpdated(with accessories: [HMAccessory]) {
        tableView.reloadData()
    }
}
