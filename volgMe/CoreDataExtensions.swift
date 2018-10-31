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
extension Bezoek:Encodable{    // datums in database zijn sinds 1970 !!!
    var departureDate:Date{get {return Date(timeIntervalSince1970:TimeInterval(self.departure_1970))}
        set {self.departure_1970 = Float(newValue.timeIntervalSince1970)}}
    var arrivalDate:Date{get {return Date(timeIntervalSince1970: TimeInterval(self.arrival_1970))}
        set {self.arrival_1970 = Float(newValue.timeIntervalSince1970)}}
    public var coordinate:CLLocationCoordinate2D{get {return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))}
        set {self.latitude = Float(newValue.latitude) ; self.longitude = Float(newValue.longitude)}
    }
    var cllocation:CLLocation {get {return CLLocation(coordinate: coordinate, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: arrivalDate)}}
    convenience init(_ visite:CLVisit){
        self.init(context:context)
        self.coordinate = visite.coordinate
        self.arrivalDate =  visite.arrivalDate
        self.departureDate = visite.departureDate
//        delegate.saveContext()
    }
    
    convenience init(_ visite:myCLVisit){
        self.init(context:context)
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(visite.latitude), longitude: CLLocationDegrees(visite.longitude))
        self.arrival_1970 =  visite.arrival_1970
        self.departure_1970 = visite.departure_1970
//        delegate.saveContext()
    }
    private enum CodingKeys : String, CodingKey {case arr,dep,lat,lon}
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.arrival_1970, forKey: .arr)
        try container.encode(self.departure_1970, forKey: .dep)
        try container.encode(self.latitude, forKey: .lat)
        try container.encode(self.longitude, forKey: .lon)
    }
}
//extension Bezoek : Encodable {
//    private enum CodingKeys: String, CodingKey { case arrival_1970,departure_1970,info,latitude,longitude}
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(arrival_1970, forKey: .arrival_1970)
//        try container.encode(departure_1970, forKey: .departure_1970)
//        try container.encode(info, forKey: .info)
//        try container.encode(latitude, forKey: .latitude)
//        try container.encode(longitude, forKey: .longitude)
//    }

//}
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
        adressen = try context.fetch(request)} catch let error {ErrMsg("fetchAdres foutje .\(error.localizedDescription)",.debug, #function)}
    return adressen.first
}

func telAdressen()->Int
{
    var adressen:[Adres] = []
    do {let request: NSFetchRequest = Adres.fetchRequest()
        adressen = try context.fetch(request)} catch let error {ErrMsg("telAdressen foutje .\(error.localizedDescription)",.debug, #function)}
    return adressen.count
}
func fetchBezoek(datum:Date_70)->Bezoek? {
    let request:NSFetchRequest = Bezoek.fetchRequest()
    request.predicate = NSPredicate(format: "arrival_1970 == %lf",datum)
    var Bezoeken:[Bezoek] = []
    do {  Bezoeken = try context.fetch(request)
    } catch let error {ErrMsg("foutje telBezoeken(.\(error.localizedDescription)",.debug, #function)}
    return Bezoeken.first
}
func telBezoeken()->Int
{
    let request:NSFetchRequest = Bezoek.fetchRequest()
    var Bezoeken:[Bezoek] = []
    do {  Bezoeken = try context.fetch(request)
    } catch let error {ErrMsg("foutje telBezoeken(.\(error.localizedDescription)",.debug, #function)}
    return Bezoeken.count
}
func fetchAlleBezoeken()->[Bezoek]{
    let request:NSFetchRequest = Bezoek.fetchRequest()
    var Bezoeken:[Bezoek] = []
    do {  Bezoeken = try context.fetch(request)
    } catch let error {ErrMsg("foutje telBezoeken(.\(error.localizedDescription)",.debug, #function)}
    return Bezoeken
}

func zoekAdressenZonderLocatieKlaar()->Bool
{
    if fetchFirstAdresZonderLocation() == nil {return true}
    checkAdressenZonderLocatie()
    return false
}

func fetchAdressen(containing : String)-> [Adres] {
    var gevonden:[Adres] = []
    do {let request: NSFetchRequest = Adres.fetchRequest()
    request.predicate = NSPredicate(format: "ANY naam CONTAINS[c] %@ OR ANY straatHuisnummer CONTAINS[c] %@OR ANY  stad CONTAINS[c] %@", containing,containing,containing)
        gevonden = try context.fetch(request)} catch let error {ErrMsg("foutje fetchNearestAdres .\(error.localizedDescription)",.error,#function)}

    return gevonden
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
        ErrMsg("afstand = \(afstand) : \(element.naam ?? "")",.debug, #function)
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
    if adres == nil {checkBezoekenZonderAdres();ErrMsg("checkAdressenZonderLocatie afgewerkt", .debug, #function);return}
    let adr = "\(adres!.straatHuisnummer ?? "") \(adres!.postcode ?? "") \(adres!.stad ?? "")"
    geocode(adr) { placemark, error in
        guard let placemark = placemark, error == nil else {
            let code = (error! as NSError).code
            switch code {case 8 : ErrMsg((adres!.naam ?? "noname") + " " + adr + " verwijderd", .warning, #function) ; context.delete(adres!);delegate.saveContext();checkAdressenZonderLocatie(); return
            default: ErrMsg("adressen geocoding overload: stopped 1 minute", .warning, #function)
                sleep(60)
                checkAdressenZonderLocatie()
                return }}
        DispatchQueue.main.async {
            //  update UI here
            adres!.coordinate = (placemark.location?.coordinate ?? nil)!
            adres!.landcode = (placemark.isoCountryCode ?? "")
            adres!.straatHuisnummer = (placemark.thoroughfare ?? "") + " " + (placemark.subThoroughfare ?? "")
            adres!.postcode = placemark.postalCode
            adres!.stad = placemark.locality
            adres!.soortPlaats = "Kennis"
            delegate.saveContext()
            sleep(UInt32(0.8))
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
    } catch let error {ErrMsg("foutje fetchFirstAdresZonderLocation(.\(error.localizedDescription)",.debug, #function)}
    ErrMsg("er zijn nog \(AdresZonderLocation.count) adressen zonder coördinaten", .debug, #function)
    return AdresZonderLocation.first
}
func fetchFirstBezoekZonderAdres()->Bezoek?
{
    let request:NSFetchRequest = Bezoek.fetchRequest()
    var BezoekenZonderAdres:[Bezoek] = []
    request.predicate = NSPredicate(format: "metAdres = nil")
    //   request.fetchLimit = 1
    do {  BezoekenZonderAdres = try context.fetch(request)
    } catch let error {ErrMsg("foutje \(error.localizedDescription)",.debug, #function)}
    ErrMsg("er zijn nog \(BezoekenZonderAdres.count) bezoeken zonder adres", .debug, #function)
    return BezoekenZonderAdres.first
}
func telBezoekenZonderAdres()->Int
{
    let request:NSFetchRequest = Bezoek.fetchRequest()
    var BezoekenZonderAdres:[Bezoek] = []
    request.predicate = NSPredicate(format: "metAdres = nil")
    //   request.fetchLimit = 1
    do {  BezoekenZonderAdres = try context.fetch(request)
    } catch let error {ErrMsg("foutje \(error.localizedDescription)",.debug, #function)}
    ErrMsg("er zijn nog \(BezoekenZonderAdres.count) bezoeken zonder adres", .debug, #function)
    return BezoekenZonderAdres.count
}


func checkBezoekenZonderAdres(){
    if let visiteZonderAdres = fetchFirstBezoekZonderAdres()
    {
        if let closestAdres = fetchNearestAdres(latitude: Double(visiteZonderAdres.latitude), longitude: Double(visiteZonderAdres.longitude), distance: 50)
        {
            visiteZonderAdres.metAdres = closestAdres
//            closestAdres.addToBezocht(visiteZonderAdres)
            delegate.saveContext()
            ErrMsg("\(telBezoekenZonderAdres())",.debug,#function)
            NotificationCenter.default.post(name: NSNotification.Name("checkBezoekenZonderAdres"), object: nil)
//            checkBezoekenZonderAdres()
            return
            
        }
        while CLGeocoder().isGeocoding
        {
            sleep(10)
        }
        ErrMsg("start Geocoding bezoek", .debug, #function)
        geocode(visiteZonderAdres.coordinate, completion: { placemark, error in
            guard let placemark = placemark, error == nil else {
                let code = (error! as NSError).code
                switch code {case 8 : ErrMsg("\(visiteZonderAdres.arrivalDate) \(visiteZonderAdres.latitude ) \(visiteZonderAdres.longitude)  verwijderd", .warning, #function) ; context.delete(visiteZonderAdres);delegate.saveContext();checkBezoekenZonderAdres(); return
                default: ErrMsg("bezoeken geocoding overload: stopped 1 minute", .warning, #function);
                    sleep(60)
                NotificationCenter.default.post(name: NSNotification.Name("checkBezoekenZonderAdres"), object: nil)
                    return }}
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
                sleep(UInt32(0.8))
                NotificationCenter.default.post(name: NSNotification.Name("checkBezoekenZonderAdres"), object: nil)
//                checkBezoekenZonderAdres()
            }
        })
    }
    else {ErrMsg("checkBezoekenZonderAdres afgewerkt", .debug, #function)
        NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
    }
    
    return
}
//func reFetchArray(key:String)-> [String]{
//    var tabellenData = [Tabellen(context: context)]
//       let request:NSFetchRequest = Tabellen.fetchRequest()
//     request.predicate = NSPredicate(format: "key = %@",key)
//    do {  tabellenData = try context.fetch(request)
//    } catch let error {ErrMsg("foutje \(error.localizedDescription)",.debug, #function)}
//    if tabellenData.count > 0 {
//    if let decodedArray = NSKeyedUnarchiver.unarchiveObject(with: tabellenData) as? [String]{
//        return decodedArray as! [String]
//        }}
//    return [String]()
//}
// let encodedData = NSKeyedArchiver.archivedData(withRootObject: array)
// if let decodedArray = NSKeyedUnarchiver.unarchiveObject(with: encodedData) as? [Any]
