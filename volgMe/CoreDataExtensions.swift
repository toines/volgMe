//
//  CoreDataExtensions.swift
//  volgMe
//
//  Created by Toine Schnabel on 25-09-18.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import MapKit

let delegate = (UIApplication.shared.delegate as! AppDelegate)
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


extension Adres : MKAnnotation
{
    public var coordinate:CLLocationCoordinate2D{get {return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)}
        set {self.latitude = newValue.latitude ; self.longitude = newValue.longitude}
    }
    public var subtitle: String? {return stad}
    public var title: String? {return naam}
}
extension Bezoek{    // datums in database zijn sinds 1970 !!!
    var departureDate:Date{get {return Date(timeIntervalSince1970:self.departure_1970)}
        set {self.departure_1970 = newValue.timeIntervalSince1970}}
    var arrivalDate:Date{get {return Date(timeIntervalSince1970: self.arrival_1970)}
        set {self.arrival_1970 = newValue.timeIntervalSince1970}}
    public var coordinate:CLLocationCoordinate2D{get {return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)}
        set {self.latitude = newValue.latitude ; self.longitude = newValue.longitude}
    }
    var cllocation:CLLocation {get {return CLLocation(coordinate: coordinate, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: arrivalDate)}}
    convenience init(_ visite:CLVisit){
        self.init(context:context)
        self.coordinate = visite.coordinate
        self.arrivalDate =  visite.arrivalDate
        self.departureDate = visite.departureDate
        delegate.saveContext()
    }
//    convenience init(_ visite:myCLVisit){
//        self.init(context:context)
//        self.coordinate = CLLocationCoordinate2D(latitude: visite.latitude, longitude: visite.longitude)
//        self.arrival_1970 =  visite.arrival_1970
//        self.departure_1970 = visite.departure_1970
//        delegate.saveContext()
//    }
}
