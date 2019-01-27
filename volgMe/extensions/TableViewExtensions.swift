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
        else if let _ = x as? visiteTableViewCell{return}
        else if let _ = x as? SearchTableViewCell{return}
        
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


