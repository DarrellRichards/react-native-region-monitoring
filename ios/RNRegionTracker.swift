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
    var exitRegion = true
    var enterRegion = false
    var radius = 10.0
}

@objc(RegionTracker)
class RegionTracker: NSObject, CLLocationManagerDelegate {
    var locationManager:CLLocationManager! = nil
    let locationUpdater = locationTracker();
    var configuration = Config()
    
    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override init() {
        super.init();
        self.checkPermissions()
    }
    
    @objc func config(_ url: String, exitRegion: Bool, enterRegion: Bool, radius: Int) -> Void {
        print(exitRegion)
        configuration.url = url
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
            let maxDistance = configuration.radius
            
            let region = CLCircularRegion(center: CLLocationCoordinate2D(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude),
                radius: maxDistance,
                identifier: "customMessageHere")
            
            region.notifyOnExit = configuration.exitRegion
            region.notifyOnEntry = configuration.enterRegion
            
            // Stop your location manager for updating location and start regionMonitoring
            self.locationManager.stopUpdatingLocation()
            self.locationManager.startMonitoring(for: region)
        }
    }
    
    private func updateDeviceLocation(location:CLLocation?) {
        locationUpdater.triggerLocationUpdate(location: location!, url: configuration.url)
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
