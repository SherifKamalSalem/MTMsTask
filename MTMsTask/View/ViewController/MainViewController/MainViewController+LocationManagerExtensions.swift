//
//  MainViewController+LocationManagerExtensions.swift
//  MTMsTask
//
//  Created by sherif kamal on 07/02/2021.
//

import Foundation
import CoreLocation
import Firebase
import MapKit

extension MainViewController: CLLocationManagerDelegate {
    private func setLocationManger() {
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.startUpdatingLocation()
    }

    private func setMapKitCurrentLocation(locationCoordinate: CLLocationCoordinate2D) {
        coordinateRegion.center = locationCoordinate
        coordinateRegion.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
         mapView.setRegion(coordinateRegion, animated: true)
         mapView.showsUserLocation = true
         mapView.isZoomEnabled = true
         mapView.annotations
            .compactMap { $0 as? MKPointAnnotation }
            .forEach { existingMarker in
                existingMarker.coordinate = locationCoordinate
        }
        mapView.addAnnotation(annotation)
        currentLocation = locationCoordinate
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    setLocationManger()
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationCoordinate = locations.last?.coordinate else {
            return
        }
        sourceLocation = locationCoordinate
        if UIApplication.shared.applicationState == .active {
            if sourceLocation != nil {
                setMapKitCurrentLocation(locationCoordinate: sourceLocation!)
            }
            if let sourceLocation = sourceLocation,
               let destinationLocation = destinationLocation {
                configureMapView(with: sourceLocation, and: destinationLocation)
            }
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .red
        render.lineWidth = 2
        return render
    }
}

extension MainViewController {
    fileprivate func configureRequest(_ requestDocument: [String : Any]) -> MTMRequest {
        var request = MTMRequest()
        if let clientName = requestDocument["clientName"] as? String {
            request.clientName = clientName
        }
        if let clientPhoto = requestDocument["clientPhoto"] as? String {
            request.clientPhoto = clientPhoto
        }
        if let drivers = requestDocument["drivers"] as? [String] {
            request.drivers = drivers.compactMap({ MTMDriver(driverId: $0) })
        }
        if let destinationLatitude = requestDocument["destinationLatitude"] as? Double,
           let destinationLongitude = requestDocument["destinationLongitude"] as? Double {
            request.destinationLatitude = destinationLatitude
            request.destinationLongitude = destinationLongitude
            self.destinationLocation = CLLocationCoordinate2DMake(destinationLatitude, destinationLongitude)

        }
        if let sourceLatitude = requestDocument["sourceLatitude"] as? Double,
           let sourceLongitude = requestDocument["sourceLongitude"] as? Double {
            request.sourceLatitude = sourceLatitude
            request.sourceLongitude = sourceLongitude
            self.sourceLocation = CLLocationCoordinate2DMake(sourceLatitude, sourceLongitude)
        }
        return request
    }

    func setupFirestore() {
        let database = Firestore.firestore()
        database.collection("Requests")
            .getDocuments { (requestsSnapshot, error) in
                guard error == nil else {
                    print(error?.localizedDescription)
                    return
                }
                guard let requestsSnapshot = requestsSnapshot else { return }
                requestsSnapshot.documents.forEach { document in
                    let requestDocument = document.data()
                    self.requests.append(self.configureRequest(requestDocument))
                    if let sourceLocation = self.sourceLocation,
                       let destinationLocation = self.destinationLocation {
                        self.configureMapView(with: sourceLocation,
                                              and: destinationLocation)
                    }
                }
                self.createBottomView()
            }
    }

    fileprivate func calculateDistance(_ directionRequest: MKDirections.Request) {
        let direction = MKDirections(request: directionRequest)
        direction.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("error", error)
                }
                return
            }
            let routes = response.routes[0]
            self.mapView.addOverlay(routes.polyline, level: .aboveRoads)

            let rect = routes.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }

    private func configureMapView(with sourceLocationCoordinate: CLLocationCoordinate2D,
                           and destinationLocationCoordinate: CLLocationCoordinate2D) {
        let sourcePlacement = MKPlacemark(coordinate: sourceLocationCoordinate)
        let destinationPlacement = MKPlacemark(coordinate: destinationLocationCoordinate)
        let sourceItem = MKMapItem(placemark: sourcePlacement)
        let destinationItem = MKMapItem(placemark: destinationPlacement)
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .any
        calculateDistance(directionRequest)
        sourceAnnotation.coordinate = sourceLocationCoordinate
        destinationAnnotation.coordinate = destinationLocationCoordinate
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        mapView.addAnnotation(sourceAnnotation)
        mapView.addAnnotation(destinationAnnotation)
        currentLocation = sourceLocationCoordinate
    }
}
