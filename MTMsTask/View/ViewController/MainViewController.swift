//
//  MainViewController.swift
//  MTMsTask
//
//  Created by sherif kamal on 05/02/2021.
//

import UIKit
import MapKit

class MainViewController: UIViewController {
    var animator: UIViewPropertyAnimator?
    @IBOutlet weak var mapView: MKMapView!

    func createBottomView() {
        guard let sub = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BottomViewController") as? BottomViewController else { return }
        self.addChild(sub)
        self.view.addSubview(sub.view)
        sub.didMove(toParent: self)
        sub.view.frame = CGRect(x: 0, y: view.frame.maxY, width: view.frame.width, height: view.frame.height)
        sub.minimize(completion: nil)
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
        createBottomView()

        let name = NSNotification.Name(rawValue: "BottomViewMoved")
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: receiveNotification(_:))
    }
}


