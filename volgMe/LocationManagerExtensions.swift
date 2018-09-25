//
//  LocationManagerExtensions.swift
//  volgMe
//
//  Created by Toine Schnabel on 24-09-18.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import Foundation
import CoreLocation

var lm : CLLocationManager?

extension LogBoekVC : CLLocationManagerDelegate{
    
    func initLocationManager()
    {
        if lm == nil {
            lm = CLLocationManager()
            lm!.requestAlwaysAuthorization()
            lm!.allowsBackgroundLocationUpdates = true
            lm!.delegate = self
            lm!.startMonitoringVisits()
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {

    }
    func  locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    }
}
