//
//  CharDetailViewController.swift
//  HCBle_Example
//
//  Created by 곽민우 on 2/26/25.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import CoreBluetooth
import HCBle
import UIKit

class CharDetailViewController: UIViewController {
    @IBOutlet var lblChar: UILabel!
    var uuid: UUID!
    var service: CBService!
    var characteristic: CBCharacteristic!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblChar.text = characteristic.uuid.uuidString
        HCBle.shared.setService(uuid: uuid, service: service)
        HCBle.shared.setChar(uuid: uuid, characteristic: characteristic)
    }

    @IBAction func onClickWrite(_ sender: UIButton) {
        print("123")
    }

    @IBAction func onClickRead(_ sender: UIButton) {
        HCBle.shared.readData(uuid: uuid)
    }

    @IBAction func onClickSubscribe(_ sender: UIButton) {
        HCBle.shared.enableNotifications(uuid: uuid)
    }
}
