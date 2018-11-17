//
//  LogBoekVC.swift
//  volgMe
//
//  Created by Toine Schnabel on 24-09-18.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import UIKit
import MapKit

var tabelData : CellGevens?
var notes = [String]() // voor notifications

class LogBoekVC: UIViewController {
    
    
    @IBOutlet var tableViewDatum: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var zoekende = false


    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
//        if geenAdressen(){
//         StoreAllContactsAdresses()
         readJson()  //lees visites uit file
//        }
        if !(tabelData != nil) {tabelData = CellGevens()}
        tabelData?.expandMaanden()
        print ("---")
        initiateSearchBar()
        vraagToestemmingVoorNotifications()
        checkForBackgroundForeground()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var selectedDate = Date_70()
        if segue.identifier == "bewerkAdres" {
            if let x = sender as? SearchTableViewCell {
                selectedDate = x.selectedDate} else {
                if let x = sender as? visiteTableViewCell {
                selectedDate = x.selectedDate}
            }
            view.endEditing(true)
            let controller = segue.destination as! AdresVC
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller.datum = selectedDate
            //            }
        }
    }

}

