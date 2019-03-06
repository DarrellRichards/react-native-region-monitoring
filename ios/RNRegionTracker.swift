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
    var url = String
    
    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override init() {
        super.init();
        self.checkPermissions()
    }
    
    @objc func config(_ url: String) -> Void {
        self.url = url
        self.setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        if #available(iOS 9.0, *) {
            locationManager?.allowsBackgroundLocationUpdates = true
        }
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startUpdatingLocation()
    }
    
    private func checkPermissions() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways){
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    private func createRegion() {
        print(self.url)
    }
    
    private func updateDeviceLocation() {
        print(self.url)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let location = locations.last
        lastLocation = location
        // Make region and again the same cycle continues.
        self.updateDeviceLocation(location: lastLocation)
        self.createRegion(location: lastLocation)
        self.locationManager.stopUpdatingLocation()
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
