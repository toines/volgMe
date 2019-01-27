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
        if (visit.arrivalDate > Date.distantPast && visit.departureDate < Date.distantFuture)
        {didVisit(Bezoek(visit))}
        else {
            let _ = IncompleetBezoek(visit)
            delegate.saveContext()
        }
        let x = telBezoeken()
        stuurNotification(title: "\(x) didVisit:", body: " arr:\(visit.arrivalDate.DD_hh_mm()) dep:\(visit.departureDate.DD_hh_mm())", badge: 0)
 //       sendNotification()
    }
    func  locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func didVisit(_ visit:Bezoek){
        
        delegate.saveContext()

    }
}

