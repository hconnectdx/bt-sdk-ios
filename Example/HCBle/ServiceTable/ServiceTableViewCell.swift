//
//  ServiceTableViewCell.swift
import CoreBluetooth
import UIKit

class ServiceTableViewCell: UITableViewCell {
    @IBOutlet var labelServiceUUID: UILabel!
    @IBOutlet var charTableView: UITableView!
    var characteristics: [CBCharacteristic]? = []

    override func awakeFromNib() {
        super.awakeFromNib()
        charTableView.delegate = self
        charTableView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension ServiceTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characteristics?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = charTableView.dequeueReusableCell(withIdentifier: "innerCell", for: indexPath) as! CharacteristicTableViewCell

        guard let characteristics = characteristics else {
            cell.labelCharUUID.text = "Characteristic is Nil"
            return cell
        }

        cell.labelCharUUID.text = characteristics[indexPath.row].uuid.uuidString

        return cell
    }
}

extension ServiceTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Characteristic"
    }
}
