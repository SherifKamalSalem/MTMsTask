//
//  BottomViewController.swift
//  MTMsTask
//
//  Created by sherif kamal on 05/02/2021.
//

import UIKit
import CoreLocation
import MapKit

class BottomViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var slideUpView: UIView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var tableView: UITableView!

    var requests = [MTMRequest]()
    var coordinateRegion = MKCoordinateRegion()
    let closeThresholdHeight: CGFloat = 100
    let openThreshold: CGFloat = UIScreen.main.bounds.height - 200
    let closeThreshold = UIScreen.main.bounds.height - 350
    var panGestureRecognizer: UIPanGestureRecognizer?
    var destinationLocation: CLLocationCoordinate2D?
    var sourceLocation: CLLocationCoordinate2D?
    var animator: UIViewPropertyAnimator?
    var address: String?
    var distanceSpeed: String?
    private var lockPan = false

    override func viewDidLoad() {
        gotPanned(0)
        super.viewDidLoad()
        setupTableView()
        tableView.reloadData()
        configureDistanceAwayFromRequest()
        configureYourAddress()
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(respondToPanGesture))
        view.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.delegate = self
        panGestureRecognizer = gestureRecognizer
    }

    func setupTableView() {
        slideUpView.roundCorners([.topLeft, .topRight], radius: 8)
        tapView.cornerRadius = 3
        tableView.register(UINib(nibName: "RequestCell", bundle: nil),
                           forCellReuseIdentifier: "RequestCell")
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
