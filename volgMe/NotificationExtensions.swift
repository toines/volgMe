//
//  NotificationExtensions.swift
//  volgMe
//
//  Created by Toine Schnabel on 24-09-18.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import Foundation
import UIKit
extension LogBoekVC{
    func checkForBackgroundForeground()
    {
        //    if !(UIDevice.current.isBatteryMonitoringEnabled){UIDevice.current.isBatteryMonitoringEnabled = true}
        //   Foreground()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.Foreground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.Background), name: UIApplication.didEnterBackgroundNotification, object: nil)
        //    NotificationCenter.default.addObserver(self, selector: #selector(visiteVC.startZoekLocatieBijContacten),name:NSNotification.Name("zoekLocatieBijContacten"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList),name:NSNotification.Name(rawValue: "load"), object: nil)
        //    NotificationCenter.default.addObserver(self, selector: #selector(visiteVC.updateKaart),name:NSNotification.Name("MAP"), object: nil)
        //    NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: .UIDeviceBatteryLevelDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goDown), name: NSNotification.Name("goDown"), object: nil)
        
    }
    @objc func loadList(){
        //    tabel.reloadData()
    }
    @objc func Foreground()
    {
        //    ErrMsg("Foreground", .debug)
        //    checkDbForMisingData()
        //    readJson()  // externe data input
    }
    @objc func Background()
    {
        //    ErrMsg("background", .debug)
    }
    @objc func goDown(){
        // voorbeeld
    }
}
