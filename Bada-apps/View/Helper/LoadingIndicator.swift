//
//  LoadingIndicator.swift
//  SearchAndZoomLocation
//
//  Created by Handy Handy on 8/24/17.
//  Copyright © 2017 Binus. All rights reserved.
//
import UIKit

class LoadingIndicator {
    let view: UIView!
    let container: UIView!
    let loadingBorderView: UIView!
    let activityIndicator: UIActivityIndicatorView!
    
    init(view: UIView) {
        self.view = view
        
        self.container = UIView()
        self.container.frame = view.frame
        self.container.center = view.center
        self.container.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        
        self.loadingBorderView = UIView()
        self.loadingBorderView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        self.loadingBorderView.center = view.center
        self.loadingBorderView.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        self.loadingBorderView.clipsToBounds = true
        self.loadingBorderView.layer.cornerRadius = 10
        
        self.activityIndicator = UIActivityIndicatorView()
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.activityIndicator.activityIndicatorViewStyle = .whiteLarge
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.center = loadingBorderView.center
        
        self.view.addSubview(container)
        self.view.addSubview(loadingBorderView)
        self.view.addSubview(activityIndicator)
        
        self.stopLoading()
        
    }
    
    func startLoading() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.container.isHidden = false
        self.loadingBorderView.isHidden = false
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        UIApplication.shared.endIgnoringInteractionEvents()
        self.container.isHidden = true
        self.loadingBorderView.isHidden = true
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
}
