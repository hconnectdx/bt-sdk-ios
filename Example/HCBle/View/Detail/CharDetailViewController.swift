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
    var service: CBService!
    var characteristic: CBCharacteristic!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblChar.text = characteristic.uuid.uuidString
        HCBle.shared.setService(service: service)
        HCBle.shared.setChar(characteristic: characteristic)
    }

    @IBAction func onClickWrite(_ sender: UIButton) {
        print("123")
    }

    @IBAction func onClickRead(_ sender: UIButton) {
        HCBle.shared.readData()
    }

    @IBAction func onClickSubscribe(_ sender: UIButton) {
        print("1235")
    }
}
