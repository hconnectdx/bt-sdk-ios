//
//  ViewController.swift
//  HCBle
//
//  Created by x-oauth-basic on 02/20/2025.
//  Copyright (c) 2025 x-oauth-basic. All rights reserved.
//

import HCBle
import UIKit

class ViewController: UIViewController {
    private var hcBle: HCBle?
    override func viewDidLoad() {
        super.viewDidLoad()
        hcBle = HCBle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onClickScan(_ sender: UIButton) {
        hcBle?.scan { peripheral, advertisementData, rssi in
            print("peripheral: \(peripheral)")
            print("advertisementData: \(advertisementData)")
            print("rssi: \(rssi)")
        }
    }
}
