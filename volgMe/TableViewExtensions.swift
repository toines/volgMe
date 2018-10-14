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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return tabelData?.kalender.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print ("tabelData?.kalender.count : \(tabelData?.kalender.count ?? 0) ?? 0")
        if let x = tabelData {
            if let y = x.datumDictionary[x.kalender[section]] {
                if y.getoond {return y.datums.count}}}
            
    
            return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let info = tabelData!.kalender[section]
                var id = ""
                switch info.count {
                case 6 : id = "maand"
                case 8: id = "dag"
                default: id = "visite"
                }
        ErrMsg("section:\(section) datum:\(info)", .debug, #function)
        let cell = tableView.dequeueReusableCell(withIdentifier: id,for: IndexPath(row: 0, section: section))
                switch id {
                case "maand": vulMaandCell(cell: cell as! maandTableViewCell, maand: info)
                default : vulDagCell(cell: cell as! dagTableViewCell, dag: info)
            }
        
        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let info = tabelData!.kalender[indexPath.row]
//        var id = ""
//        switch info.0.count {
//        case 6 : id = "maand"
//        case 8: id = "dag"
//        default: id = "visite"
//        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "visite", for: indexPath)
//        switch id {
//        case "maand": vulMaandCell(cell: cell as! maandTableViewCell, maand: info.0)
//        case "dag": vulDagCell(cell: cell as! dagTableViewCell, dag: info.0)
        if let x = tabelData {
            if let y = x.datumDictionary[x.kalender[indexPath.section]] {
                vulVisiteCell(cell: cell as! visiteTableViewCell, forDatum:y.datums[indexPath.row],visite :x.kalender[indexPath.section])}
        }
        if (indexPath.row % 2) == 1 {cell.backgroundColor = UIColor(red: 0, green: 0.8, blue: 0.5, alpha: 1)} else {cell.backgroundColor = UIColor(red: 0, green: 0.8, blue: 0.6, alpha: 1)}
        return cell
    }
    func vulMaandCell(cell:maandTableViewCell ,maand:String){
        var x = ""
        for plaats in tabelData?.datumDictionary[maand]?.plaatsen ?? Set<String>() {x = x + "\(plaats) " }
        cell.landen.text = "\(x)"
        cell.jaar.text = String(maand.prefix(4))
        cell.maand.text = maand.toDate().MMMM
        cell.knop.setTitle(maand, for: .normal)
    }
    func vulDagCell(cell:dagTableViewCell ,dag:String){
        var x = ""
        if let y = tabelData?.datumDictionary[dag]?.plaatsen {
            for plaats in y {x = x + "\(plaats) " }
        }
        cell.stad.text = x
        cell.datum.text = "\(dag.toDate().EEEE()) : \(dag.toDate().d_MMMM_yyyy)"
        cell.knop.setTitle(dag, for: .normal)
//        cell.dag.text = dag.toDate().EEEE()
    }
    func vulVisiteCell(cell:visiteTableViewCell, forDatum : Date_70,visite: String)
    {
        if let x = fetchBezoek(datum: forDatum) {
            if x.arrivalDate.dd == visite.suffix(2) {cell.van.text = x.arrivalDate.hh_mm()} else {cell.van.text = "....."}
            if x.departureDate.dd == visite.suffix(2) {cell.tot.text = x.departureDate.hh_mm()} else {cell.tot.text = "....."}
            if let y = x.metAdres
            {
            cell.stad.text = y.stad
                cell.naam.text = y.naam
                cell.straat.text = y.straatHuisnummer
            }
//            cell.datum.text = forDatum.date.ddMMM
        }
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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
//    var kalender = [(String,Date_70)]()
    var dagTabel = [String:[Date_70]]()
    var kalender = [String]()
     struct dictData{
        var getoond = false
        var bijgewerkt = false
        var plaatsen = Set<String>()
        var datums = [Date_70]()
    }
    var datumDictionary = [String:dictData]()
//    struct visite {var inhoud = [String]()}
//    struct dag {var inhoud = [String:visite]()}
//    var maand = [String:dag]()
    var cellData = [String]()
//    func expandVisitesVoor(dag:String) {
//        kalender = sortKalender(kalender + datumDictionary[dag]!.datums.map{(dag + "0",$0)})}
//    func collapseVisitesVoor(dag:String){
//        kalender = sortKalender(kalender.filter{$0.0.count < 9 || $0.0.prefix(8) != dag})
//    }
    func collapseDagenVoor(maand:String){
        let x = kalender.filter{$0.count == 8 && $0.prefix(6) == maand}
        for dag in x {
          var y = datumDictionary[dag]
            y?.getoond = false
          datumDictionary[dag] = y
        }
        
        kalender = kalender.filter{$0.count < 7 || $0.prefix(6) != maand}
        
    }
    func handleVisitesVoor(dag:String) {
        var x = datumDictionary[dag]
        if let y = x?.getoond {x?.getoond = !y}
        datumDictionary[dag] = x
    }

     func vulCellData(){
        cellData = (datumDictionary.filter{$0.value.getoond == true}).keys.sorted()
    }
    func expandMaanden() {let x = (datumDictionary.filter{$0.key.count == 6}).keys.sorted()
        kalender = x}
    func expandDagenVoor(maand:String) {
        kalender = (kalender + (datumDictionary.filter{$0.key.count == 8  && $0.key.prefix(6) == maand}).keys).sorted()
        
    }
        
    func handleDagenVoor(maand:String) {
        if ((kalender.filter{$0.prefix(6) == maand}).count) == 1 {expandDagenVoor(maand: maand)}
        else {collapseDagenVoor(maand: maand)}
    }

     
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
