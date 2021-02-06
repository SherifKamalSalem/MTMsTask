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

    private func setCurrentLocationName(currentLocation: CLLocationCoordinate2D) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinateRegion.center.latitude,
                                  longitude: coordinateRegion.center.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placeMarks, error) -> Void in
                                            guard let placeMark = placeMarks?.first else { return }
                                            var streetName = ""
                                            if let street = placeMark.thoroughfare {
                                                streetName += street + " /"
                                            }
                                            if let country = placeMark.country {
                                                streetName += country + " /"
                                            }
                                            if let zip = placeMark.isoCountryCode {
                                                streetName += zip
                                            }

                                            if streetName.isEmpty {
                                                self.pickupLocationLbl.text = ""
                                            } else {
                                                self.pickupLocationLbl.text = streetName
                                            }
                                        })
    }
    
    @IBAction func acceptBtnAction(_ sender: Any) {
    }

    @IBAction func rejectBtnAction(_ sender: Any) {
    }
}
