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

class DetailViewController: UIViewController {
    @IBOutlet var deviceName: UILabel!
    @IBOutlet var serviceTableView: UITableView!

    var peripheral: CBPeripheral?
    private var services: [CBService] = []
    private var serviceChar: [(myService: CBService, myCharacteristic: CBCharacteristic)] = []
    private var expandedIndexPaths = Set<IndexPath>()

    override func viewDidLoad() {
        super.viewDidLoad()
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
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
                onDiscoverCharacteristics: { service, characteristics in
                    for charac in characteristics {
                        self.serviceChar.append((service, charac))
                    }
                    self.serviceTableView.reloadData()
                }
            )
        } else {
            print("Error")
        }
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceChar.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = serviceTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServiceTableViewCell

        let service = serviceChar[indexPath.row].myService
        let characteristics = serviceChar[indexPath.row].myCharacteristic

        cell.labelServiceUUID.text = "Service: " + service.uuid.uuidString
        cell.labelCharUUID.text = " - Char: " + characteristics.uuid.uuidString

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = serviceChar[indexPath.row]

        guard let nextVC = storyboard?.instantiateViewController(withIdentifier: "CharDetailViewController") as? CharDetailViewController else { return }
        nextVC.characteristic = selectedRow.myCharacteristic
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension DetailViewController: UITableViewDelegate {}
