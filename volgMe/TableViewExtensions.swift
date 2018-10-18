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
        if zoekende {return 1} else {return tabelData?.dagTabel.count ?? 0}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if zoekende {return tabelData?.zoekResultaten.count ?? 0} else {
        if let x = tabelData {
            if let y = x.dagTabel[x.dagTabel.keys.sorted()[section]]
            {
            return y.count
            }
        }
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if zoekende {
            let cell = tableView.dequeueReusableCell(withIdentifier: "aantalGevonden",for: IndexPath(row: 0, section: section)) as! searchHeaderViewCell
            cell.textVeld.text = "\(tabelData?.zoekResultaten.count ?? 0) resultaten gevonden"
            return cell
        }
//        let info = tabelData!.kalender[section]
          let info = tabelData!.dagTabel.keys.sorted()[section]
                var id = ""
                switch info.count {
                case 6 : id = "maand"
                case 8: id = "dag"
                default: id = "visite"
                }
//        ErrMsg("section:\(section) datum:\(info)", .debug, #function)
        let cell = tableView.dequeueReusableCell(withIdentifier: id,for: IndexPath(row: 0, section: section))
                switch id {
                case "maand": vulMaandCell(cell: cell as! maandTableViewCell, maand: info)
                default : vulDagCell(cell: cell as! dagTableViewCell, dag: info)
            }
        
        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if zoekende {
           let cell = tableView.dequeueReusableCell(withIdentifier: "gevonden", for: indexPath)  as! SearchTableViewCell
            if let x = tabelData {
                cell.vulZoekCell(datum: x.zoekResultaten.sorted()[indexPath.row])
            }
           return cell
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "visite", for: indexPath) as! visiteTableViewCell
        if let  x = tabelData {
            let y = (tabelData!.dagTabel.keys.sorted()[indexPath.section])
            let z = tabelData!.dagTabel[y]
            cell.vulVisiteCell(forDatum:z![indexPath.row],visite :x.dagTabel.keys.sorted()[indexPath.section])}
        if (indexPath.row % 2) == 1 {cell.backgroundColor = UIColor(red: 0, green: 0.8, blue: 0.5, alpha: 1)} else {cell.backgroundColor = UIColor(red: 0, green: 0.8, blue: 0.6, alpha: 1)}
            return cell}
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
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
}




class CellGevens {
//    var kalender = [(String,Date_70)]()
    var dagTabel = [String:[Date_70]]()
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
       
        dagTabel = dagTabel.filter{$0.key.count < 7 || $0.key.prefix(6) != maand}
        
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
        
        let y = (datumDictionary.filter{$0.key.count == 6}).keys
        for z in y {dagTabel[z] = [Date_70]()}
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
