//
//  DetailViewController.swift
//  HCBle_Example
//
//  Created by 곽민우 on 2/21/25.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import CoreBluetooth
import HCBle
import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tbService: UITableView!
    @IBOutlet var deviceName: UILabel!
    var peripheral: CBPeripheral?
    private var hcBle: HCBle?

    override func viewDidLoad() {
        super.viewDidLoad()
        tbService.delegate = self
        tbService.dataSource = self
        deviceName.text = peripheral?.name
    }

    @IBAction func onClickConnect(_ sender: UIButton) {
        if let peripheral = peripheral {
            hcBle?.connect(peripheral: peripheral) { peripheral, isConnect, _ in
                print(peripheral)
                print(isConnect)
            }
        } else {
            print("Error")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        return cell
    }
}
