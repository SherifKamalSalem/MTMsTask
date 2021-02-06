//
//  BottomViewController+UITableViewExtension.swift
//  MTMsTask
//
//  Created by sherif kamal on 07/02/2021.
//

import UIKit
import CoreLocation
import MapKit

extension BottomViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as! RequestCell
        cell.configureCell(request: requests[indexPath.row])
        cell.distanceAwayLbl.text = distanceSpeed ?? nil
        cell.pickupLocationLbl.text = address ?? nil
        return cell
    }
}

extension BottomViewController: CLLocationManagerDelegate {
    func configureDistanceAwayFromRequest() {
        if let sourceLatitude = sourceLocation?.latitude,
           let sourceLongitude = sourceLocation?.longitude,
           let destinationLatitude = destinationLocation?.latitude,
           let destinationLongitude = destinationLocation?.longitude {
            let source = CLLocation(latitude: sourceLatitude, longitude: sourceLongitude)
            let destination = CLLocation(latitude: destinationLatitude, longitude: destinationLongitude)
            let distance = source.distance(from: destination).binade
            let speed = " | " + (source.speed.description) + " " + "M/S"
            distanceSpeed = String(format: "%.1f", distance) + " " + "Meters" + speed
        }
    }

    func configureYourAddress() {
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
            self.address = streetName
        })
    }
}
