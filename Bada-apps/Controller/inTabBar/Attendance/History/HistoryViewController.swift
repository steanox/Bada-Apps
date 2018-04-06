//
//  History.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

class HistoryViewController: BaseController {
    
    var attendanceViewController: AttendanceViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-6-[button]", options: [], metrics: nil, views: ["button": button]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[button]", options: [], metrics: nil, views: ["button": button]))
    }
    
    @objc func buttonTapped() {
        attendanceViewController?.disableInteractivePlayerTransitioning = true
        self.dismiss(animated: true) { [unowned self] in
            self.attendanceViewController?.disableInteractivePlayerTransitioning = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
