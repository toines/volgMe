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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print ("tabelData?.kalender.count : \(tabelData?.kalender.count ?? 0) ?? 0")
        return tabelData?.kalender.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = tabelData!.kalender[indexPath.row]
        var id = ""
        switch info.0.count {
        case 6 : id = "maand"
        case 8: id = "dag"
        default: id = "visite"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        switch id {
        case "maand": vulMaandCell(cell: cell as! maandTableViewCell, maand: info.0)
        case "dag": vulDagCell(cell: cell as! dagTableViewCell, dag: info.0)
        default: vulVisiteCell(cell: cell as! visiteTableViewCell, visite: info.0,forDatum: info.1)
        }
        return cell
    }
    func vulMaandCell(cell:maandTableViewCell ,maand:String){
        var x = ""
        for plaats in tabelData?.datumDictionary[maand]?.plaatsen ?? Set<String>() {x = x + "\(plaats) " }
        cell.landen.text = "\(x)"
        cell.jaar.text = String(maand.prefix(4))
        cell.maand.text = maand.toDate().MMMM
    }
    func vulDagCell(cell:dagTableViewCell ,dag:String){
        var x = ""
        for plaats in tabelData?.datumDictionary[dag]?.plaatsen ?? Set<String>() {x = x + "\(plaats) " }
        cell.stad.text = x
        cell.datum.text = dag.toDate().ddMMM       
        cell.dag.text = dag.toDate().EEEE()
    }
    func vulVisiteCell(cell:visiteTableViewCell, visite:String, forDatum : Date_70)
    {
        if let x = fetchBezoek(datum: forDatum) {
            if x.arrivalDate.dd == visite.suffix(3).prefix(2) {cell.van.text = x.arrivalDate.hh_mm()} else {cell.tot.text = "....."}
            if x.departureDate.dd == visite.suffix(3).prefix(2) {cell.tot.text = x.departureDate.hh_mm()} else {cell.tot.text = "....."}
            if let y = x.metAdres
            {
            cell.stad.text = y.stad
                if let naam = y.naam {cell.naamOfStraat.text = naam} else
                {cell.naamOfStraat.text = y.straatHuisnummer}
            }
//            cell.datum.text = forDatum.date.ddMMM
        }
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let x = tabelData?.kalender[indexPath.row].0 {
            if x.count == 6 {tabelData?.handleDagenVoor(maand: x) }
            if x.count == 8 {tabelData?.handleVisitesVoor(dag: x) }
            tableView.reloadData()
        }
    }
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            let context = fetchedResultsController.managedObjectContext
    //            context.delete(fetchedResultsController.object(at: indexPath))
    //
    //            do {
    //                try context.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nserror = error as NSError
    //                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    //            }
    //        }
    //    }
    //
    //    func configureCell(_ cell: UITableViewCell, withEvent event: Event) {
    //        cell.textLabel!.text = event.timestamp!.description
    //    }
    
}

class CellGevens {
    var kalender = [(String,Date_70)]()
    func sortKalender (_ din:[(String,Date_70)]) -> [(String,Date_70)] {
        return din.sorted{($0.0, $0.1) < ($1.0,$1.1)}
    }
    struct dictData{
        var getoond = false
        var bijgewerkt = false
        var plaatsen = Set<String>()
        var datums = [Date_70]()
    }
    var datumDictionary = [String:dictData]()
    struct visite {var inhoud = [String]()}
    struct dag {var inhoud = [String:visite]()}
    var maand = [String:dag]()
    var cellData = [String]()
    func expandVisitesVoor(dag:String) {
        kalender = sortKalender(kalender + datumDictionary[dag]!.datums.map{(dag + "0",$0)})}
    func collapseVisitesVoor(dag:String){
        kalender = sortKalender(kalender.filter{$0.0.count < 9 || $0.0.prefix(8) != dag})
    }
    func collapseDagenVoor(maand:String){
        kalender = sortKalender(kalender.filter{$0.0.count < 7 || $0.0.prefix(6) != maand})
    }
    func handleVisitesVoor(dag:String) {
        if ((kalender.filter{$0.0.prefix(8) == dag}).count) == 1 {expandVisitesVoor(dag: dag)}
        else {collapseVisitesVoor(dag: dag)}}

     func vulCellData(){
        cellData = (datumDictionary.filter{$0.value.getoond == true}).keys.sorted()
    }
    func expandMaanden() {let x = (datumDictionary.filter{$0.key.count == 6}).keys.sorted()
        kalender = x.map{($0,Date_70())}
    }
    func expandDagenVoor(maand:String) {
        let x = (datumDictionary.filter{$0.key.count == 8  && $0.key.prefix(6) == maand}).keys.sorted()
        kalender = sortKalender(kalender + x.map{($0,Date_70())})}
    func handleDagenVoor(maand:String) {
        if ((kalender.filter{$0.0.prefix(6) == maand}).count) == 1 {expandDagenVoor(maand: maand)}
        else {collapseDagenVoor(maand: maand)}}
//        let x = (datumDictionary.filter{$0.key.count == 8  && $0.key.prefix(6) == maand}).keys.sorted()
//        kalender = sortKalender(kalender + x.map{($0,Date_70())})}

     
    func insert(_ bezoek:Bezoek){
        let dagen = datums(van: bezoek.arrival_1970, totEnMet: bezoek.departure_1970)
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
        vulCellData()
    }
    init() {
        let bezoeken = fetchAlleBezoeken()
        for bezoek in bezoeken{
            insert(bezoek)
        }
    }
}
