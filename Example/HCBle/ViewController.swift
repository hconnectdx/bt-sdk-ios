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
    override func viewDidLoad() {
        super.viewDidLoad()
        HCBle().printHello()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
