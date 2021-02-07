//
//  RequestCell.swift
//  MTMsTask
//
//  Created by sherif kamal on 06/02/2021.
//

import UIKit
import Kingfisher
import CoreLocation
import MapKit

class RequestCell: UITableViewCell {

    @IBOutlet weak var passengerImageView: UIImageView!
    @IBOutlet weak var driverNameLbl: UILabel!
    @IBOutlet weak var distanceAwayLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var pickupLocationLbl: UILabel!
    private var coordinateRegion = MKCoordinateRegion()

    func configureCell(request: MTMRequest) {
        driverNameLbl.text = request.clientName ?? nil
        passengerImageView.cornerRadius = 25
        if let urlStr = request.clientPhoto, let url = URL(string: urlStr) {
            passengerImageView.kf.setImage(with: url)
        }
    }
    
    @IBAction func acceptBtnAction(_ sender: Any) {
    }

    @IBAction func rejectBtnAction(_ sender: Any) {
    }
}
