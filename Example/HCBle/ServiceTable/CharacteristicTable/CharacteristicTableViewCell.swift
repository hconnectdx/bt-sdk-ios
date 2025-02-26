//
//  CharacteristicTableViewCell.swift
//  HCBle_Example
//
//  Created by 곽민우 on 2/25/25.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

class CharacteristicTableViewCell: UITableViewCell {
    @IBOutlet var labelCharUUID: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
