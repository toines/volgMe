//
//  NotificationExtensions.swift
//  volgMe
//
//  Created by Toine Schnabel on 24-09-18.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import Foundation
import UIKit
 func Foreground()
{
    ErrMsg("Foreground", .debug,#function)
    if zoekAdressenZonderLocatieKlaar() {
        NotificationCenter.default.post(name: NSNotification.Name("checkBezoekenZonderAdres"), object: nil)
        
    }
    ErrMsg ("#adressen:\(telAdressen()) #bezoeken:\(telBezoeken())",.debug, #function)
    print("--------- ", #function)
}
func Background()
{
    ErrMsg("background", .debug, #function)
}
var checkBezoekenZonderAdresBezig = false

extension LogBoekVC{
    func checkForBackgroundForeground()
    {
        //    if !(UIDevice.current.isBatteryMonitoringEnabled){UIDevice.current.isBatteryMonitoringEnabled = true}
        //   Foreground()
        
        //    NotificationCenter.default.addObserver(self, selector: #selector(visiteVC.startZoekLocatieBijContacten),name:NSNotification.Name("zoekLocatieBijContacten"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList),name:NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAdresBezoeken),name:NSNotification.Name(rawValue: "checkBezoekenZonderAdres"), object: nil)

        //    NotificationCenter.default.addObserver(self, selector: #selector(visiteVC.updateKaart),name:NSNotification.Name("MAP"), object: nil)
        //    NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: .UIDeviceBatteryLevelDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goDown), name: NSNotification.Name("goDown"), object: nil)
        
    }
    
    @objc func updateAdresBezoeken()
    {
        ErrMsg("checkBezoekenZonderAdres()", .debug, #function)
        checkBezoekenZonderAdres()
//        NotificationCenter.default.post(name: NSNotification.Name("checkBezoekenZonderAdres"), object: nil)
    }
    @objc func loadList(){
        //    tabel.reloadData()
    }

    @objc func goDown(){
        // voorbeeld
    }
    
}
