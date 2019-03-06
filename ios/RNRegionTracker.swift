//
//  RNRegionTracker.swift
//  RNRegionMonitoring
//
//  Created by Darrell Richards on 3/5/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

@objc(RegionTracker)
class RegionTracker: NSObject, CLLocationManagerDelegate {
    var lastLocation:CLLocation? = nil
    var locationManager:CLLocationManager! = nil
    
    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override init() {
        super.init();
        self.checkPermissions()
    }
    
    @objc func config(_ url: String) -> Void {
        print(url)
        self.setupLocationManager(url: url)
    }
    
    func setupLocationManager(url: String) {
        print(url)
    }
    
    func checkPermissions() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            print("We have the permissions")
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited Region")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered Region")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Updated Location")
    }
}
