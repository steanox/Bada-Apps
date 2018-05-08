//
//  CoverageAreaView.swift
//  Bada-apps
//
//  Created by Handy Handy on 07/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class CoverageAreaView: UIView, CLLocationManagerDelegate {

    @IBOutlet weak var beaconImageView: UIImageView!
    @IBOutlet weak var beaconLabel: UILabel!
    
    fileprivate weak var coverageAreaNibView: UIView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var distanceToBeacon: CLProximity?
    var beacon: Beacon = Beacon()
    var manager = CBCentralManager()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let coverageArea: UIView = UINib.loadView(with: Identifier.coverageArea, self)
        self.addSubview(coverageArea)
        self.coverageAreaNibView = coverageArea
        
        self.beaconImageView.image = #imageLiteral(resourceName: "Beacon-NotDetected")
        self.beaconLabel.text = Message.notInArea
        self.beaconLabel.textColor = UIColor(rgb: Color.beaconTextColor)
        self.beacon.beaconNotDetected()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        coverageAreaNibView.frame = self.bounds
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            print("yes")
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                if CLLocationManager.isRangingAvailable(){
                    startScanning()
                }
            }
        }else {
            print("Not")
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func startScanning(){
        let uuid = UUID(uuidString: Identifier.beaconUuid)!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 3, minor: 284, identifier: Identifier.beacon)
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if beacons.count > 0 {
            updateDistance(beacons[0].proximity)
        } else {
            updateDistance(.unknown)
        }
    }
    
    func updateDistance(_ distance: CLProximity){
        distanceToBeacon = distance
        UIView.animate(withDuration: 0.5) {
            if self.manager.state == .poweredOff{
                self.beacon.beaconNotDetected()
                self.beaconImageView.image = #imageLiteral(resourceName: "Beacon-NotDetected")
                self.beaconLabel.text = "Please turn on your bluetooth"
            }else{
                switch distance {
                case .unknown:
                    self.beacon.beaconNotDetected()
                    self.beaconImageView.image = #imageLiteral(resourceName: "Beacon-NotDetected")
                    self.beaconLabel.text = Message.notInArea
                case .far:
                    self.beacon.beaconNotDetected()
                    self.beaconImageView.image = #imageLiteral(resourceName: "Beacon-Finding")
                    self.beaconLabel.text = Message.finding
                case .near , .immediate:
                    self.beacon.beaconDetected()
                    self.beaconImageView.image = #imageLiteral(resourceName: "Beacon-Detected")
                    self.beaconLabel.text = Message.inArea
                }
            }

        }
    }
    
    
}
