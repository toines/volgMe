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
        if geenAdressen(){
//         StoreAllContactsAdresses()
         readJsonAdressen()
         readJsonBezoeken()  //lees visites uit file
        }
        stuurNotification(title: "Start monitoring visits",body: "\(Date().yyyy_MM_dd_HH_mm_ss)", badge: 0)

        print ("---")
        cleanupBezoeken()
        initiateSearchBar()
        vraagToestemmingVoorNotifications()
        checkForBackgroundForeground()

        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
//        scrollToBottom()
    }
    
    func scrollToBottom(){
        if let x = tabelData{
            let lastIndex = NSIndexPath(row: x.dagTabel.keys.sorted().last?.count ?? 0, section: x.dagTabel.count - 1)
            tableViewDatum.scrollToRow(at: lastIndex as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)}
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
//    override func will

}

