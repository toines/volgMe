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
extension Bezoek : Encodable {
    private enum CodingKeys: String, CodingKey { case arrival_1970,departure_1970,info,latitude,longitude}
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(arrival_1970, forKey: .arrival_1970)
        try container.encode(departure_1970, forKey: .departure_1970)
        try container.encode(info, forKey: .info)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
}
extension Adres : Encodable {
    private enum CodingKeys: String, CodingKey { case confirmed,info,landcode,latitude,longitude,naam,postcode,provincie,soortPlaats,stad,straatHuisnummer}
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(confirmed, forKey: .confirmed)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(naam, forKey: .naam)
        try container.encode(postcode, forKey: .postcode)
        try container.encode(provincie, forKey: .provincie)
        try container.encode(soortPlaats, forKey: .soortPlaats)
        try container.encode(stad, forKey: .stad)
        try container.encode(straatHuisnummer, forKey: .straatHuisnummer)
    }
}

