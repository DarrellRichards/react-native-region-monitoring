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

struct Config {
    var url = String()
}

@objc(RegionTracker)
class RegionTracker: NSObject, CLLocationManagerDelegate {
    var locationManager:CLLocationManager! = nil
    let locationUpdater = locationTracker();
    var config = Config()
    
    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override init() {
        super.init();
        self.checkPermissions()
    }
    
    @objc func config(_ url: String) -> Void {
        config(url)
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
    
    private func createRegion(location:CLLocation?) {
        if (CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self)) {
            let coordinate = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
            let maxDistance = 10.0
            
            let region = CLCircularRegion(center: CLLocationCoordinate2D(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude),
                radius: maxDistance,
                identifier: "customMessageHere")
            
            region.notifyOnExit = true
            region.notifyOnEntry = false
            
            // Stop your location manager for updating location and start regionMonitoring
            self.locationManager.stopUpdatingLocation()
            self.locationManager.startMonitoring(for: region)
        }
    }
    
    private func updateDeviceLocation(location:CLLocation?) {
        print(config)
        locationUpdater.triggerLocationUpdate(location: location!, url: config.url)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        locationManager.stopMonitoring(for: region)
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        locationManager.stopMonitoring(for: region)
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        // Make region and again the same cycle continues.
        self.updateDeviceLocation(location: location)
        self.createRegion(location: location)
        self.locationManager.stopUpdatingLocation()
    }
}
