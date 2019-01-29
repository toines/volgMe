//
//  Cellgegevens.swift
//  volgMe
//
//  Created by Toine Schnabel on 27/01/2019.
//  Copyright © 2019 Toine Schnabel. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class CellGevens {
    //    var kalender = [(String,Date_70)]()
    var oldTableEntries = [tabelentry]()
    var newTableEntries = Set<tabelentry>()
    var dagTabel = [String:[Date_70]]() {
        //        willSet {newTableEntries = Set<tabelentry>()}
        didSet {fillNewTableEntries()}
    }
    func checkGemisteVisites() {
        let gemisteVisites = fetchAlleGemisteVisites()
        for vis in gemisteVisites {
            print ("\(#function) arr: \(vis.arrivalDate.yyyy_MM_dd_HH_mm_ss) dep: \(vis.departureDate.yyyy_MM_dd_HH_mm_ss)")
            if let x = fetchBezoek(datum: vis.arrival_1970) {
                print ("\(#function) \(x.arrivalDate.yyyy_MM_dd_HH_mm_ss) - \(x.departureDate.yyyy_MM_dd_HH_mm_ss) Wordt verwijderd")
                context.delete(vis)
            }
        }
        delegate.saveContext()
    }

    func fillNewTableEntries(){
        newTableEntries = Set<tabelentry>()
        for x in dagTabel {
            newTableEntries.insert(tabelentry(x.key))
            for y in x.value {
                newTableEntries.insert(tabelentry(String(x.key.prefix(8)),y))
            }
        }
    }
    //    var tabelEntries = [tabelentry]()
    
    func getDeltaTableEntries()->([tabelentry],Int){
        let delta = newTableEntries.count - oldTableEntries.count
        let deltaEntries = newTableEntries.subtracting(oldTableEntries)
        oldTableEntries = newTableEntries.sorted(by: {($0.datumValue,Float($0.tijdstip ?? 0)) < ($1.datumValue, Float($1.tijdstip ?? 0))})
        return (Array(deltaEntries).sorted(by: {($0.datumValue,Float($0.tijdstip ?? 0)) < ($1.datumValue, Float($1.tijdstip ?? 0))}),delta)
    }
    var zoekResultaten = [Date_70]()
    //    var kalender = [String]()
    struct dictData:Codable{
        var getoond = false
        var bijgewerkt = false
        var plaatsen = Set<String>()
        var datums = [Date_70]()
    }
    var datumDictionary = [String:dictData]()
    
    func collapseDagenVoor(maand:String){
        
        let x = dagTabel.filter{$0.key.count < 7 || $0.key.prefix(6) != maand}
        dagTabel = x
        
    }
    func handleVisitesVoor(dag:String) {
        if let x = dagTabel[dag] {
            if x.count > 0 {dagTabel[dag] = [Date_70]()} else {dagTabel[dag] = datumDictionary[dag]?.datums}
            
        }
    }
    
    func expandMaanden() {
        
        let y = (datumDictionary.filter{$0.key.count == 6}).keys.sorted()
        for z in y {
            dagTabel[z] = [Date_70]()
        }
    }
    func expandDagenVoor(maand:String) {
        let y = (datumDictionary.filter{$0.key.count == 8  && $0.key.prefix(6) == maand}).keys
        for z in y {dagTabel[z] = [Date_70]()}
    }
    
    func handleDagenVoor(maand:String) {
        if ((dagTabel.filter{$0.key.prefix(6) == maand}).count) == 1 {expandDagenVoor(maand: maand)}
        else {collapseDagenVoor(maand: maand)}
    }
    
    
    func insert(_ bezoek:Bezoek){
        let dagen = datums(van: bezoek.arrival_1970, totEnMet: bezoek.departure_1970)
        if dagen.count > 1 {
            print("\(#function) van:\(bezoek.arrivalDate.d_M_yyyy) tot: \(bezoek.departureDate.d_M_yyyy)")
        }
        for dag in dagen
        {
            if let x = datumDictionary[dag.date.yyyyMM] {
                var landen = x.plaatsen
                if let land = bezoek.metAdres?.landcode {landen.insert(land)}
                datumDictionary[dag.date.yyyyMM] = dictData(getoond:true,bijgewerkt:false,plaatsen: landen,datums : x.datums)
            }
            else{
                var landen = Set<String>()
                if let land = bezoek.metAdres?.landcode {landen.insert(land)}
                datumDictionary[dag.date.yyyyMM] = dictData(getoond:true,bijgewerkt:false,plaatsen: landen,datums : [Date_70]())}
            if let x = datumDictionary[dag.date.yyyyMMdd] {
                var steden = x.plaatsen
                if let stad = bezoek.metAdres?.stad {steden.insert(stad)}
                datumDictionary[dag.date.yyyyMMdd] = dictData(getoond:false,bijgewerkt:false,plaatsen: steden,datums : x.datums + [bezoek.arrival_1970])}
            else {
                var steden = Set<String>()
                if let stad = bezoek.metAdres?.stad {steden.insert(stad)}
                datumDictionary[dag.date.yyyyMMdd] = dictData(getoond:false,bijgewerkt:false,plaatsen: steden,datums : [bezoek.arrival_1970])
            }
        }
        //        vulCellData()
    }
    init() {
        let bezoeken = fetchAlleBezoeken()
        for bezoek in bezoeken{
            insert(bezoek)
        }
        checkGemisteVisites()
    }
    
}
