//
//  MainViewController.swift
//  MTMsTask
//
//  Created by sherif kamal on 05/02/2021.
//

import UIKit
import MapKit
import FirebaseFirestore

protocol MainViewControllerDelegate {
  func toggleLeftPanel()
  func collapseSidePanels()
}

class MainViewController: UIViewController {
    var animator: UIViewPropertyAnimator?
    @IBOutlet weak var mapView: MKMapView!

    let annotation = MKPointAnnotation()
    var locationManger = CLLocationManager()
    var coordinateRegion = MKCoordinateRegion()
    let sourceAnnotation = MKPointAnnotation()
    let destinationAnnotation = MKPointAnnotation()
    var currentLocation: CLLocationCoordinate2D?
    var destinationLocation: CLLocationCoordinate2D?
    var sourceLocation: CLLocationCoordinate2D?
    var requests = [MTMRequest]()

    var delegate: MainViewControllerDelegate?

    func createBottomView() {
        guard let bottomViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BottomViewController") as? BottomViewController else { return }
        bottomViewController.requests = requests
        bottomViewController.sourceLocation = sourceLocation
        bottomViewController.destinationLocation = destinationLocation
        bottomViewController.coordinateRegion = coordinateRegion
        self.addChild(bottomViewController)
        self.view.addSubview(bottomViewController.view)
        bottomViewController.didMove(toParent: self)
        bottomViewController.view.frame = CGRect(x: 0, y: view.frame.maxY, width: view.frame.width, height: view.frame.height)
        bottomViewController.minimize(completion: nil)
    }

    func subViewGotPanned(_ percentage: Int) {
        guard let propAnimator = animator else {
            animator = UIViewPropertyAnimator(duration: 3, curve: .linear, animations: {
                self.mapView.alpha = 1
            })
            animator?.startAnimation()
            animator?.pauseAnimation()
            return
        }
        propAnimator.fractionComplete = CGFloat(percentage) / 100
    }

    func receiveNotification(_ notification: Notification) {
        guard let percentage = notification.userInfo?["percentage"] as? Int else { return }
        subViewGotPanned(percentage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirestore()
        let name = NSNotification.Name(rawValue: "BottomViewMoved")
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: receiveNotification(_:))
    }

    // MARK: Button actions
    @IBAction func leftBtnTapped(_ sender: Any) {
      delegate?.toggleLeftPanel()
    }
}
