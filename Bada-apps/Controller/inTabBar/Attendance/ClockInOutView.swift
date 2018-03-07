//
//  ClockInOutView.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit

enum Clock {
    case _in
    case _out
}

class ClockInOutView: UIView {

    @IBOutlet weak var clockInOutButton: UIButton!
    @IBOutlet weak var clockInOutTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    fileprivate weak var clockInOutArea: UIView!
    
    var clock = Clock._out
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let clockInOut: UIView = UINib.loadView(with: Identifier.clockInOut, self)
        self.addSubview(clockInOut)
        self.clockInOutArea = clockInOut
        
        dateLabel.textColor = UIColor(rgb: Color.dateClockInOut)
        
        updateUI(clock: ._out)
        talk()
    }
    
    @IBAction func clockInOutDidTap(_ sender: UIButton) {
        updateUI(clock: clock)
    }
    
    func updateUI (clock: Clock) {
        switch clock {
        case ._in:
            clockInOutButton.imageView?.image = #imageLiteral(resourceName: "clockOutButton")
            self.clock = ._out
        case ._out:
            print("a")
            clockInOutButton.imageView?.image = #imageLiteral(resourceName: "clockInButton")
            self.clock = ._in
        }
    }
    
    func talk() {
        print("masuk")
    }
    
}
