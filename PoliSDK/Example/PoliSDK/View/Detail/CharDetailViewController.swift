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

    @IBAction func onClickP1(_ sender: UIButton) {
        print("onClick P1")
    }

    @IBAction func onClickP2(_ sender: UIButton) {
        print("onClick P2")
    }

    @IBAction func onClickP3(_ sender: UIButton) {
        print("onClick P3")
    }

    @IBAction func onClickP4(_ sender: UIButton) {
        print("onClick P4")
    }

    @IBAction func onClickP5(_ sender: UIButton) {
        print("onClick P5")
    }

    @IBAction func onClickP6(_ sender: UIButton) {
        print("onClick P6")
    }

    @IBAction func onClickP7(_ sender: UIButton) {
        print("onClick P7")
    }

    @IBAction func onClickP8(_ sender: UIButton) {
        print("onClick P8")
    }

    @IBAction func onClickP9(_ sender: UIButton) {
        print("onClick P9")
    }
}
