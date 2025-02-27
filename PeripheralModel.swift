//
//  HCPeripheral.swift
//  HCBle
//
//  Created by 곽민우 on 2/27/25.
//

import CoreBluetooth
import Foundation

class PeripheralModel {
    var selService: CBService?
    var selChar: CBCharacteristic?
    var peripheral: CBPeripheral?

    init(selService: CBService? = nil, selChar: CBCharacteristic? = nil, peripheral: CBPeripheral? = nil) {
        self.selService = selService
        self.selChar = selChar
        self.peripheral = peripheral
    }
}
