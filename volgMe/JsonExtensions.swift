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
    if visites.count > 0 {
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
    }
    return cleanedTable
}



func readJson() {

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    var bezoekenUitJson = [myCLVisit]()
    do {
    if let fileUrl =  Bundle.main.url(forResource: "visitsNew", withExtension: "json")
    {
        let jsonData = try Data(contentsOf: fileUrl)
        bezoekenUitJson = try decoder.decode([myCLVisit].self, from: jsonData as Data)
        print (bezoekenUitJson.count)
        print(bezoekenUitJson)
        print (bezoekenUitJson[0].arrival_1970.date.HHmm)
        
    } else {print("no data")}
        let bezoeken = fetchAlleBezoeken()
        for bezoek in bezoeken{
            bezoekenUitJson.append(myCLVisit(bezoek))
        }
        bezoekenUitJson = bezoekenUitJson.sorted(by:{($0.arrival_1970,$0.departure_1970,($0.info ?? "")) < ($1.arrival_1970,$1.departure_1970,($1.info ?? ""))})
//    bezoeken = bezoeken.sorted(by:{($0.arrival_1970,$0.departure_1970,($0.info ?? "")) < ($1.arrival_1970,$1.departure_1970,($1.info ?? ""))})
        var toev = "first"
        var filteredFromJson = [myCLVisit]()
        var prevBezoek : myCLVisit?
        for bezoek in bezoekenUitJson {
            if bezoek.info == " JSON" {
                if let pre = prevBezoek {
                if pre.arrival_1970 != bezoek.arrival_1970 {
                    toev = "toevoegen"
                    filteredFromJson.append(bezoek)
                }
                }
            }
            
            print ("\(bezoek.arrival_1970.date.yyyy_MM_dd_HH_mm_ss)   \(bezoek.departure_1970.date.yyyy_MM_dd_HH_mm_ss)  \(String(format: "%.8f",bezoek.latitude))  \(String(format: "%.8f",bezoek.longitude))  \(bezoek.info ?? "") \(toev)  ")
            prevBezoek = bezoek
            toev = ""
        }
        bezoekenUitJson = filteredFromJson
    bezoekenUitJson = clean(bezoekenUitJson)
    for bezoek in bezoekenUitJson {
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
//        delegate.saveContext()        
        }
    }   catch {print ("Error",error)}
}

class myCLVisit:Codable,CustomStringConvertible {  // tijdelijk
    let info : String?
    var  latitude : Float
    var longitude : Float
    var departure_1970 : Date_70
    var arrival_1970 : Date_70
    private enum CodingKeys : String, CodingKey {case arr,dep,lat,lon}
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.arrival_1970, forKey: .arr)
        try container.encode(self.departure_1970, forKey: .dep)
        try container.encode(self.latitude, forKey: .lat)
        try container.encode(self.longitude, forKey: .lon)
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.arrival_1970 = try container.decode(Date_70.self, forKey: .arr)
        self.departure_1970 = try container.decode(Date_70.self, forKey: .dep)
        self.latitude = try container.decode(Float.self, forKey: .lat)
        self.longitude = try container.decode(Float.self, forKey: .lon)
        self.info = " JSON"

    }

    public var coordinate:CLLocationCoordinate2D{
        get {return CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))}
        set {latitude = Float(newValue.latitude); longitude = Float(newValue.longitude)}}
    init(_ visit:CLVisit) {
        
        info = ""
        latitude = Float(visit.coordinate.latitude)
        longitude = Float(visit.coordinate.longitude)
        departure_1970 = Date_70(visit.departureDate)
        arrival_1970 = Date_70(visit.arrivalDate)
    }
    init(_ visit:Bezoek) {
        
        info = ""
        latitude = Float(visit.latitude)
        longitude = Float(visit.longitude)
        departure_1970 = Date_70(visit.departureDate)
        arrival_1970 = Date_70(visit.arrivalDate)
    }
    var description:String {
        return "\(arrival_1970.date.yyyyMMdd ) => "
    }
}



