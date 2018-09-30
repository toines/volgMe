//
//  CoreDataExtensions.swift
//  volgMe
//
//  Created by Toine Schnabel on 25-09-18.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation
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
    
    convenience init(_ visite:myCLVisit){
        self.init(context:context)
        self.coordinate = CLLocationCoordinate2D(latitude: visite.latitude, longitude: visite.longitude)
        self.arrival_1970 =  Double(visite.arrival_1970)
        self.departure_1970 = Double(visite.departure_1970)
        delegate.saveContext()
    }
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
func geenAdressen()->Bool{
    if fetchFirstAdres() == nil {return true} else {return false}
}
func fetchFirstAdres()->Adres? //return 1 adres
{
    var adressen:[Adres] = []
    do {let request: NSFetchRequest = Adres.fetchRequest()
        adressen = try context.fetch(request)} catch let error {ErrMsg("fetchAdres foutje .\(error.localizedDescription)",.debug)}
    return adressen.first
}

func telAdressen()->Int
{
    var adressen:[Adres] = []
    do {let request: NSFetchRequest = Adres.fetchRequest()
        adressen = try context.fetch(request)} catch let error {ErrMsg("telAdressen foutje .\(error.localizedDescription)",.debug)}
    return adressen.count
}

func telBezoeken()->Int
{
    let request:NSFetchRequest = Bezoek.fetchRequest()
    var Bezoeken:[Bezoek] = []
    do {  Bezoeken = try context.fetch(request)
    } catch let error {ErrMsg("foutje telBezoeken(.\(error.localizedDescription)",.debug)}
    return Bezoeken.count
}

func zoekAdressenZonderLocatieKlaar()->Bool
{
    checkAdressenZonderLocatie()
    return false
}
func bezoekenZonderAdresKlaar()->Bool
{
    return false
}
func fetchNearestAdres(latitude:Double,longitude:Double,distance:Double)->Adres? //return 1 adres
{
    let maxDelta = 0.002
    let maxLat = (latitude + maxDelta) as Double
    let minLat = (latitude - maxDelta) as Double
    let maxLon = (longitude + maxDelta) as Double
    let minLon = (longitude - maxDelta) as Double
    
    var naburigeAdressen:[Adres] = []
    do {let request: NSFetchRequest = Adres.fetchRequest()
        request.predicate = NSPredicate(format: "latitude > %f AND latitude < %f AND longitude > %f AND longitude < %f", minLat, maxLat,minLon,maxLon)
        naburigeAdressen = try context.fetch(request)} catch let error {print("foutje fetchNearestAdres .\(error.localizedDescription)")}
    var kortsteAfstand = distance
    //        print (">>>> \(kortsteAfstand)")
    var indexKortsteAfstand = 999999
    for (index,element) in naburigeAdressen.enumerated()
    {
        let afstand = CLLocation(latitude: element.latitude, longitude: element.longitude).distance(from: CLLocation.init(latitude: latitude, longitude: longitude))
        ErrMsg("afstand = \(afstand) : \(element.naam ?? "")",.debug)
        if afstand < kortsteAfstand {kortsteAfstand = afstand
            indexKortsteAfstand = index}
    }
    if indexKortsteAfstand < 999999
    {
        print ("Gewonnen : \(naburigeAdressen[indexKortsteAfstand].naam ?? "")")
    }
    
    if kortsteAfstand != distance {return naburigeAdressen[indexKortsteAfstand]}
    
    //        print ("geen closestAdres?")
    return nil
}
func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
    CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
}
func geocode(_ coordinate:CLLocationCoordinate2D, completion: @escaping (CLPlacemark?, Error?) -> ())  {
    CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { completion($0?.first, $1) }
}
func geocode(_ location:String, completion: @escaping (CLPlacemark?,Error?)->()){
    CLGeocoder().geocodeAddressString(location){ completion($0?.first, $1)}
}

func checkAdressenZonderLocatie(){
    let adres = fetchFirstAdresZonderLocation()
    if adres == nil {checkBezoekenZonderAdres();ErrMsg("checkAdressenZonderLocatie afgewerkt", .debug);return}
    let adr = "\(adres!.straatHuisnummer ?? "") \(adres!.postcode ?? "") \(adres!.stad ?? "")"
    geocode(adr) { placemark, error in
        guard let placemark = placemark, error == nil else {
            let code = (error! as NSError).code
            switch code {case 8 : ErrMsg((adres!.naam ?? "noname") + " " + adr + " verwijderd", .warning) ; context.delete(adres!);delegate.saveContext();checkAdressenZonderLocatie(); return
            default: ErrMsg("adressen geocoding overload: stopped till next start", .warning) ; return }}
        DispatchQueue.main.async {
            //  update UI here
            adres!.coordinate = (placemark.location?.coordinate ?? nil)!
            adres!.landcode = (placemark.isoCountryCode ?? "")
            adres!.straatHuisnummer = (placemark.thoroughfare ?? "") + (placemark.subThoroughfare ?? "")
            adres!.postcode = placemark.postalCode
            adres!.stad = placemark.locality
            adres!.soortPlaats = "Kennis"
            delegate.saveContext()
            sleep(1)
            checkAdressenZonderLocatie()
        }
    }
    
}
func fetchFirstAdresZonderLocation()->Adres?
{
    let request:NSFetchRequest = Adres.fetchRequest()
    var AdresZonderLocation:[Adres] = []
    request.predicate = NSPredicate(format: "latitude = 0")
    do {  AdresZonderLocation = try context.fetch(request)
    } catch let error {ErrMsg("foutje fetchFirstAdresZonderLocation(.\(error.localizedDescription)",.debug)}
    ErrMsg("er zijn nog \(AdresZonderLocation.count) adressen zonder coördinaten", .debug)
    return AdresZonderLocation.first
}
func fetchFirstBezoekZonderAdres()->Bezoek?
{
    let request:NSFetchRequest = Bezoek.fetchRequest()
    var BezoekenZonderAdres:[Bezoek] = []
    request.predicate = NSPredicate(format: "metAdres = nil")
    //   request.fetchLimit = 1
    do {  BezoekenZonderAdres = try context.fetch(request)
    } catch let error {ErrMsg("foutje fetchFirstBezoekZonderAdres(.\(error.localizedDescription)",.debug)}
    ErrMsg("er zijn nog \(BezoekenZonderAdres.count) bezoeken zonder adres", .debug)
    return BezoekenZonderAdres.first
}

func checkBezoekenZonderAdres(){
    if let visiteZonderAdres = fetchFirstBezoekZonderAdres()
    {
        if let closestAdres = fetchNearestAdres(latitude: visiteZonderAdres.latitude, longitude: visiteZonderAdres.longitude, distance: 50)
        {
            visiteZonderAdres.metAdres = closestAdres
            //            closestAdres.addToBezocht(visiteZonderAdresUitDB)}
            delegate.saveContext()
            checkBezoekenZonderAdres()
            return
            
        }
        while CLGeocoder().isGeocoding
        {
            sleep(10)
        }
        ErrMsg("start Geocoding bezoek", .debug)
        geocode(visiteZonderAdres.coordinate, completion: { placemark, error in
            guard let placemark = placemark, error == nil else {
                let code = (error! as NSError).code
                switch code {case 8 : ErrMsg("\(visiteZonderAdres.arrivalDate) \(visiteZonderAdres.latitude ) \(visiteZonderAdres.longitude)  verwijderd", .warning) ; context.delete(visiteZonderAdres);delegate.saveContext();checkBezoekenZonderAdres(); return
                default: ErrMsg("bezoeken geocoding overload: stopped till next start", .warning) ; return }}
            DispatchQueue.main.async {
                //  update UI here
                let adres = Adres(context: context)
                adres.coordinate = (placemark.location?.coordinate ?? nil)!
                adres.landcode = (placemark.isoCountryCode ?? "")
                adres.straatHuisnummer = (placemark.thoroughfare ?? "") + (placemark.subThoroughfare ?? "")
                adres.postcode = placemark.postalCode
                adres.stad = placemark.locality
                visiteZonderAdres.metAdres = adres
                delegate.saveContext()
                sleep(1)
                checkBezoekenZonderAdres()
            }
        })
    }
    else {ErrMsg("checkBezoekenZonderAdres afgewerkt", .debug)}
}


