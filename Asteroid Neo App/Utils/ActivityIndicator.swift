//
//  ActivityIndicator.swift
//  Asteroid Neo App
//
//  Created by Kashware Dev on 10/11/21.
//

import UIKit

let gActivityIndicator = ActivityIndicator.shared
class ActivityIndicator: NSObject {

    static let shared = ActivityIndicator()
    
    lazy var bgView: UIView = {
        let view = UIView(frame: keyWindow!.bounds)
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.addSubview(activityIndicator)
        keyWindow?.addSubview(view)
        keyWindow?.sendSubviewToBack(view)
        return view
    }()
    
    lazy var activityIndicator: NVActivityIndicatorView = {
        let activity = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: (keyWindow?.frame.width ?? 0)/2-25, y: (keyWindow?.frame.height ?? 0)/2-25), size: CGSize(width: 50, height: 50)), color: .green)
        return activity
    }()
    
    func startAnimating() {
        keyWindow?.bringSubviewToFront(bgView)
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        keyWindow?.sendSubviewToBack(bgView)
        activityIndicator.stopAnimating()
    }
}
