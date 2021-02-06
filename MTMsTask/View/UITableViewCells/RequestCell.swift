//
//  RequestCell.swift
//  MTMsTask
//
//  Created by sherif kamal on 06/02/2021.
//

import UIKit

class RequestCell: UITableViewCell {

    @IBOutlet weak var passengerImageView: UIImageView!
    @IBOutlet weak var driverNameLbl: UILabel!
    @IBOutlet weak var distanceAwayLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var pickupLocationLbl: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func acceptBtnAction(_ sender: Any) {
    }

    @IBAction func rejectBtnAction(_ sender: Any) {
    }
}
