//
//  TableViewExtensions.swift
//  volgMe
//
//  Created by Toine Schnabel on 24-09-18.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import Foundation
import UIKit


extension LogBoekVC: UITableViewDelegate,UITableViewDataSource  {
    // MARK: - Table View
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 70.0
    //    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if zoekende {return tabelData?.zoekResultaten.count ?? 0} else {
            return tabelData?.oldTableEntries.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let x = tableViewDatum.cellForRow(at: indexPath)
        if let cell = x as? maandTableViewCell {cell.geselecteerd()}
        else if let cell = x as? dagTableViewCell {cell.geselecteerd()}
        else if let cell = x as? visiteTableViewCell{return}
        else if let cell = x as? SearchTableViewCell{return}
        
        if let x = tabelData?.getDeltaTableEntries()
        {
            let delta = x.1
            var indexTabel = [IndexPath]()
            for row in indexPath.row...indexPath.row + abs(delta) - 1 {indexTabel.append(IndexPath(row:row + 1,section:0))}
            if delta > 0 {tableViewDatum.insertRows(at: indexTabel, with: .fade)
  //              tableViewDatum.scrollToRow(at: indexTabel.last!, at: UITableView.ScrollPosition.bottom, animated: true)
            }
             else {tableViewDatum.deleteRows(at: indexTabel, with: .fade)}
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if zoekende {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gevonden", for: indexPath)  as! SearchTableViewCell
            if let x = tabelData {
                cell.vulZoekCell(datum: x.zoekResultaten.sorted()[indexPath.row])
            }
            return cell
        } else {
            let entry = tabelData!.oldTableEntries[indexPath.row]
            var id = ""
            let value = entry.datumValue
            switch value.count  {
            case 6 : id = "maand"
            case 8: id = "dag"
            default: id = "visite"
            }
            switch id {
            case "maand": let cell = tableView.dequeueReusableCell(withIdentifier: id,for: indexPath) as! maandTableViewCell
            cell.vulMaandCell(maand: value)
            return cell
            case "dag" : let cell = tableView.dequeueReusableCell(withIdentifier: id,for: indexPath) as! dagTableViewCell
            cell.vulDagCell(dag: value)
            return cell
            default:
                let x = entry.tijdstip
                let cell = tableView.dequeueReusableCell(withIdentifier: "visite", for: indexPath) as! visiteTableViewCell
                cell.vulVisiteCell(forDatum:x!,visite :String(entry.datumValue.prefix(8)))
                if (indexPath.row % 2) == 1 {cell.backgroundColor = UIColor(red: 0, green: 0.8, blue: 0.5, alpha: 1)} else {cell.backgroundColor = UIColor(red: 0, green: 0.8, blue: 0.6, alpha: 1)}
                return cell
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
}

struct tabelentry:Hashable {
    var datumValue = ""
    var tijdstip : Date_70?
    init(_ datumValue:String,_ tijdstip:Date_70) {self.tijdstip = tijdstip  ; self.datumValue = datumValue + "00"}
    init(_ datumValue:String) {self.datumValue = datumValue}
}


class CellGevens {
    //    var kalender = [(String,Date_70)]()
    var oldTableEntries = [tabelentry]()
    var newTableEntries = Set<tabelentry>()
    var dagTabel = [String:[Date_70]]() {
        //        willSet {newTableEntries = Set<tabelentry>()}
        didSet {fillNewTableEntries()}
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
    //    func getTableEntries()->[tabelentry]{
    //        if tabelEntries.count == 0 {
    //            for x in dagTabel.sorted(by: {$0.key<$1.key}) {
    //                tabelEntries.append(tabelentry(x.key))
    //                for y in x.value.sorted() {
    //                    tabelEntries.append(tabelentry(String(x.key.prefix(8)),y))
    //                }
    //            }
    //        }
    //        return tabelEntries
    //    }
    
    
    var zoekResultaten = [Date_70]()
    //    var kalender = [String]()
    struct dictData{
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
        //        var x = datumDictionary[dag]     //oud
        //        if let y = x?.getoond {x?.getoond = !y}     //oud
        //        datumDictionary[dag] = x     //oud
        
        if let x = dagTabel[dag] {
            if x.count > 0 {dagTabel[dag] = [Date_70]()} else {dagTabel[dag] = datumDictionary[dag]?.datums}
            
        }
    }
    
    //     func vulCellData(){
    //        cellData = (datumDictionary.filter{$0.value.getoond == true}).keys.sorted()
    //    }
    func expandMaanden() {
        //        let x = (datumDictionary.filter{$0.key.count == 6}).keys.sorted()  // oud
        //        kalender = x   // oud
        
        let y = (datumDictionary.filter{$0.key.count == 6}).keys.sorted()
        for z in y {
            dagTabel[z] = [Date_70]()
        }
    }
    func expandDagenVoor(maand:String) {
        //        kalender = (kalender + (datumDictionary.filter{$0.key.count == 8  && $0.key.prefix(6) == maand}).keys).sorted()  // oud
        
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
        
    }
    
}
