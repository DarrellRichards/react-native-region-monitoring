//
//  locationManager.swift
//  RNRegionMonitoring
//
//  Created by Darrell Richards on 3/6/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import MapKit
import Alamofire
import SwiftyJSON

class locationTracker {
    func triggerLocationUpdate(location: CLLocation, url: String) {
        let parameters = [
            "loc": [
                "type": "Point",
                "coordinates": [location.coordinate.longitude as Any, location.coordinate.latitude as Any]
            ]
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding(options: []), headers: headers).responseString { (data) in
            print("We posted to server")
        }
    }
}
