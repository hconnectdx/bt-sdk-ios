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
                onDiscoverServices: { services in
                    for service in services {
                        self.services.append(service)
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
        return services.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = serviceTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServiceTableViewCell

        cell.labelServiceUUID.text = services[indexPath.row].uuid.uuidString
        cell.characteristics = services[indexPath.row].characteristics ?? nil
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Services"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if expandedIndexPaths.contains(indexPath) {
            expandedIndexPaths.remove(indexPath)
        } else {
            expandedIndexPaths.insert(indexPath)
        }

        serviceTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 100

        // 펼쳐진 상태일 때 추가적인 높이를 줌
        if expandedIndexPaths.contains(indexPath) {
            height += 150 // 펼쳐졌을 때 추가된 높이 (예시로 100을 설정)
        }
        return height
    }
}
