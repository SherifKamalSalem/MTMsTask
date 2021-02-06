//
//  BottomViewController.swift
//  MTMsTask
//
//  Created by sherif kamal on 05/02/2021.
//

import UIKit
import CoreLocation
import MapKit

protocol LocationManagerUpdateDelegate {
    func updateLocation()
}

class BottomViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var slideUpView: UIView!
    @IBOutlet weak var tableView: UITableView!

    var requests = [MTMRequest]()
    private var coordinateRegion = MKCoordinateRegion()
    let closeThresholdHeight: CGFloat = 100
    let openThreshold: CGFloat = UIScreen.main.bounds.height - 200
    let closeThreshold = UIScreen.main.bounds.height - 100
    var panGestureRecognizer: UIPanGestureRecognizer?
    var destinationLocation: CLLocationCoordinate2D?
    var sourceLocation: CLLocationCoordinate2D?
    var animator: UIViewPropertyAnimator?
    var address: String?
    var distanceSpeed: String?
    weak var delegate: LocationManagerUpdateDelegate?
    private var lockPan = false

    override func viewDidLoad() {
        gotPanned(0)
        super.viewDidLoad()
        setupTableView()
        tableView.reloadData()
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(respondToPanGesture))
        view.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.delegate = self
        panGestureRecognizer = gestureRecognizer
    }

    func setupTableView() {
        slideUpView.roundCorners([.topLeft, .topRight], radius: 8)
        tableView.register(UINib(nibName: "RequestCell", bundle: nil), forCellReuseIdentifier: "RequestCell")
    }

    func gotPanned(_ percentage: Int) {
        if animator == nil {
            animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
                let scaleTransform = CGAffineTransform(scaleX: 1, y: 5).concatenating(CGAffineTransform(translationX: 0, y: 240))
            })
            animator?.isReversed = true
            animator?.startAnimation()
            animator?.pauseAnimation()
        }
        animator?.fractionComplete = CGFloat(percentage) / 100
    }

    // MARK: methods to make the view draggable

    @objc func respondToPanGesture(recognizer: UIPanGestureRecognizer) {
        guard !lockPan else { return }
        if recognizer.state == .ended {
            let maxY = UIScreen.main.bounds.height - CGFloat(openThreshold)
            lockPan = true
            if maxY > self.view.frame.minY {
                maximize { self.lockPan = false }
            } else {
                minimize { self.lockPan = false }
            }
            return
        }
        let translation = recognizer.translation(in: self.view)
        moveToY(self.view.frame.minY + translation.y)
        recognizer.setTranslation(.zero, in: self.view)
    }

    func maximize(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveToY(40)
        }) { _ in
            if let completion = completion {
                completion()
            }
        }
    }

    func minimize(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveToY(self.closeThreshold)
        }) { _ in
            if let completion = completion {
                completion()
            }
        }
    }

    private func moveToY(_ position: CGFloat) {
        view.frame = CGRect(x: 0, y: position, width: view.frame.width, height: view.frame.height)

        let maxHeight = view.frame.height - closeThresholdHeight
        let percentage = Int(100 - ((position * 100) / maxHeight))

        gotPanned(percentage)

        let name = NSNotification.Name(rawValue: "BottomViewMoved")
        NotificationCenter.default.post(name: name, object: nil, userInfo: ["percentage": percentage])
    }
}

extension BottomViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as! RequestCell
        cell.configureCell(request: requests[indexPath.row])
        return cell
    }
}

extension BottomViewController: CLLocationManagerDelegate {
    fileprivate func setDistanceWithSpeed(_ locations: [CLLocation]) {
        if let longitude = destinationLocation?.longitude,
           let latitude = destinationLocation?.latitude {
            let distance = locations.last?.distance(from: CLLocation(latitude: latitude, longitude: longitude)).binade
            let speed = " | " + (locations.last?.speed.description ?? "--") + " " + "M/S"
            distanceSpeed = String(format: "%.1f", distance ?? 0.0) + " " + "Meters" + speed
        }
    }

    private func setCurrentLocationName(currentLocation: CLLocationCoordinate2D) {
        // Add below code to get address for touch coordinates.
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinateRegion.center.latitude,
                                  longitude: coordinateRegion.center.longitude)
        geoCoder.reverseGeocodeLocation(location,
                                        completionHandler: { (placeMarks, error) -> Void in
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
