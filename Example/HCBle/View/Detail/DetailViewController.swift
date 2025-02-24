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
    @IBOutlet var deviceName: UILabel!
    @IBOutlet var tbService: UITableView!
    @IBOutlet var serviceTableView: UITableView!

    var peripheral: CBPeripheral?
    private var serviceUUIds: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tbService.delegate = self
        tbService.dataSource = self
        deviceName.text = peripheral?.name
    }

    @IBAction func onClickConnect(_ sender: UIButton) {
        if let peripheral = peripheral {
            HCBle.shared.connect(
                peripheral: peripheral,
                onConnState: { isConnected, error in
                    if isConnected {
                        print("Successfully connected to \(peripheral.name ?? "Unknown Device")")
                    } else {
                        print("Failed to connect: \(error?.localizedDescription ?? "Unknown error")")
                    }
                },
                onDiscoverServices: { services in
                    for service in services {
                        print(service.uuid.uuidString)
                        self.serviceUUIds.append(service.uuid.uuidString)
                    }
                    self.serviceTableView.reloadData()
                }
            )
        } else {
            print("Error")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceUUIds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = serviceTableView.dequeueReusableCell(withIdentifier: "ServiceUUIDCell", for: indexPath) as! ServiceTableViewCell

        cell.labelUUID.text = serviceUUIds[indexPath.row]
        return cell
    }
}
