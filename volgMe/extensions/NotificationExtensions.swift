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
    if !(tabelData != nil) {
        tabelData = CellGevens()
    }
    tabelData?.expandMaanden()

    if zoekAdressenZonderLocatieKlaar() {
        NotificationCenter.default.post(name: NSNotification.Name("checkBezoekenZonderAdres"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
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
        NotificationCenter.default.addObserver( self, selector: #selector (self.keyboardWillShow), name : UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                name: UIResponder.keyboardWillHideNotification, object: nil)

        
    }
    @objc func keyboardWillShow( notification:NSNotification )
    {
        // read the CGRect from the notification (if any)
        if let newFrame = (notification.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsets( top: 0, left: 0, bottom: newFrame.height, right: 0 )
            tableViewDatum.contentInset = insets
            tableViewDatum.scrollIndicatorInsets = insets
            ErrMsg("keyboard van grootte veranderd", .debug, #function)
        }
    }
    @objc func keyboardWillHide(notification:NSNotification )
    {
        // read the CGRect from the notification (if any)
        if ((notification.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue) != nil {
            let insets = UIEdgeInsets( top: 0, left: 0, bottom: 0, right: 0 )
//            let insets = UIEdgeInsets( top: 0, left: 0, bottom: newFrame.height, right: 0 )
            tableViewDatum.contentInset = insets
            tableViewDatum.scrollIndicatorInsets = insets
            ErrMsg("keyboard van grootte veranderd", .debug, #function)
        }
    }
    @objc func updateAdresBezoeken()
    {
        ErrMsg("checkBezoekenZonderAdres()", .debug, #function)
        checkBezoekenZonderAdres()
        
//        NotificationCenter.default.post(name: NSNotification.Name("checkBezoekenZonderAdres"), object: nil)
    }
    @objc func loadList(){
            tableViewDatum.reloadData()
    }

    @objc func goDown(){
        // voorbeeld
    }
    
}
