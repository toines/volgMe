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

class LogBoekVC: UIViewController {
    @IBOutlet var tableViewDatum: UITableView!
    @IBOutlet var kaart: MKMapView!
    @IBOutlet var knoppenView: UIStackView!
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
        if geenAdressen(){
         StoreAllContactsAdresses()
         readJson()  //lees visites uit file
        }
        if !(tabelData != nil) {tabelData = CellGevens()}
//        print ("---")
//        tabelData?.expandMaanden()
//        print(tabelData?.kalender)
//        print(tabelData?.kalender.count)
//        tabelData?.expandDagenVoor(maand: "201808")
//        print(tabelData?.kalender)
//        print(tabelData?.kalender.count)
//        tabelData?.expandVisitesVoor(dag: "20180831")
//        print(tabelData?.kalender)
//        print(tabelData?.kalender.count)
//        tabelData?.colapseVisitesVoor(dag: "20180831")
//        print(tabelData?.kalender)
//        print(tabelData?.kalender.count)
//        tabelData?.colapseDagenVoor(maand: "201808")
//        print(tabelData?.kalender)
//        print(tabelData?.kalender.count)


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

}
