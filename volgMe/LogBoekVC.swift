//
//  LogBoekVC.swift
//  volgMe
//
//  Created by Toine Schnabel on 24-09-18.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import UIKit

class LogBoekVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
        if geenAdressen(){
         StoreAllContactsAdresses()
         readJson()
        }
        if zoekAdressenZonderLocatieKlaar() {if bezoekenZonderAdresKlaar(){}}
        ErrMsg ("#adressen:\(telAdressen()) #bezoeken:\(telBezoeken())",.debug)
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
