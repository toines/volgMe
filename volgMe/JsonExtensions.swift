//
//  JsonExtensions.swift
//  volgMe
//
//  Created by Toine Schnabel on 25/09/2018.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


//===============================================================================================================================
// verwijderd dubbele data, voegt gesplitste visites samen, vewijderd ongeldige visites
//===============================================================================================================================
func clean(_ visites:[myCLVisit])->[myCLVisit]{
    var cleanedTable = [myCLVisit]()
    var prevVisit = visites[0]
    for visit in visites {
        var goeiePrevVisit = false
        if (prevVisit.arrival_1970 == visit.arrival_1970) && (prevVisit.departure_1970 == visit.departure_1970) && (abs(prevVisit.latitude - visit.latitude) < 0.01) && (abs(prevVisit.longitude - visit.longitude) < 0.01){}
        else {goeiePrevVisit = true}
        if (abs(prevVisit.latitude - visit.latitude) < 0.01) && (abs(prevVisit.longitude - visit.longitude) < 0.01) && prevVisit.departure_1970.date.HHmm == "00:00" && visit.arrival_1970.date.HHmm == "00:00" && goeiePrevVisit {
            visit.arrival_1970 = prevVisit.arrival_1970
            goeiePrevVisit = !goeiePrevVisit}
        if goeiePrevVisit && prevVisit.departure_1970.date.HHmm == "00:00" {
            goeiePrevVisit = !goeiePrevVisit}
        if goeiePrevVisit {cleanedTable.append(prevVisit)}
        prevVisit = visit
    }
    cleanedTable.append(prevVisit)
    print ("\(visites.count) after \(cleanedTable.count)")
    return cleanedTable
}



func readJson() {

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    var bezoeken = [myCLVisit]()
    do {
    if let fileUrl =  Bundle.main.url(forResource: "visits", withExtension: "json")
    {
        let jsonData = try Data(contentsOf: fileUrl)
        bezoeken = try decoder.decode([myCLVisit].self, from: jsonData as Data)
        print (bezoeken.count)
        print (bezoeken[0].arrival_1970.date.HHmm)
        
    } else {print("no data")}
    bezoeken = bezoeken.sorted(by:{($0.arrival_1970,$0.departure_1970) < ($1.arrival_1970,$1.departure_1970)})
    bezoeken = clean(bezoeken)
    for bezoek in bezoeken {
        let lat = String(format: "%.8f",bezoek.latitude)
        let long = String(format: "%.8f",bezoek.longitude)
        var skipVanwegeDatumDeparture = ""
        if bezoek.departure_1970.date.HHmm == "00:00" {skipVanwegeDatumDeparture = "D>>>>>> "}
        var skipVanwegeDatumArrival = ""
        if bezoek.arrival_1970.date.HHmm == "00:00" {skipVanwegeDatumArrival = "A>> "}
        var dagen = ""
        for dag in (datums(van: bezoek.arrival_1970, totEnMet: bezoek.departure_1970)){
            dagen = dagen + "\(dag.date.yyyyMMdd)."
        }
        print (skipVanwegeDatumDeparture + skipVanwegeDatumArrival + "\(bezoek.arrival_1970.date.dd_MM_yyyy_HH_mm)   \(bezoek.departure_1970.date.dd_MM_yyyy_HH_mm)....\(long) - \(lat)     \(dagen)")
        let _ = Bezoek(bezoek)
        
        }
    }   catch {print ("Error",error)}
}

class myCLVisit:Codable {  // tijdelijk
    let info : String?
    var  latitude : Double
    var longitude : Double
    var departure_1970 : Date_70
    var arrival_1970 : Date_70
    public var coordinate:CLLocationCoordinate2D{
        get {return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)}
        set {latitude = newValue.latitude; longitude = newValue.longitude}}
    init(_ visit:CLVisit) {
        
        info = ""
        latitude = visit.coordinate.latitude
        longitude = visit.coordinate.longitude
        departure_1970 = Date_70(visit.departureDate)
        arrival_1970 = Date_70(visit.arrivalDate)
    }
}



