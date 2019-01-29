//
//  NotificationExtensions.swift
//  volgMe
//
//  Created by Toine Schnabel on 24-09-18.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import Foundation
import UIKit

func Background()
{
    ErrMsg("background", .debug, #function)
}
var checkBezoekenZonderAdresBezig = false

extension LogBoekVC{
    @objc func Foreground()
    {
        ErrMsg("Foreground", .debug,#function)
        if !(tabelData != nil) {
            tabelData = CellGevens()
        }
        tabelData?.expandMaanden()
        
        
        
        if zoekAdressenZonderLocatieKlaar() {
            NotificationCenter.default.post(name: NSNotification.Name("checkBezoekenZonderAdres"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
            //        NotificationCenter.default.post(name: NSNotification.Name("scrollToBottom"), object: nil)
        }
        if let x = tabelData {
            let deltas = x.getDeltaTableEntries()
            var newIndexPaths = [IndexPath]()
            if deltas.1 == 0 {return}
//            for x in 0...(deltas.1 - 1) {insertRow(IndexPath(row: x, section: 0))}
            for x in 0...(deltas.1 - 1) {newIndexPaths.append(IndexPath(row:x,section:0))  }
            tableViewDatum.insertRows(at: newIndexPaths, with: .middle)
            if let v = tableViewDatum.indexPathsForVisibleRows?.last?.row{
            if (newIndexPaths.last?.row ?? 0 > v)
            {
                tableViewDatum.scrollToRow(at: newIndexPaths.last!, at: UITableView.ScrollPosition.bottom, animated: true)
               // This indeed is an indexPath no longer visible
                // Do something to this non-visible cell...
                }}
        }
        ErrMsg ("#adressen:\(telAdressen()) #bezoeken:\(telBezoeken())",.debug, #function)
        print("--------- ", #function)
        
    }
    // moet nog geimplementeerd worden. probleem is het aantal rows moet per row omhoog gezet worden. 
    func insertRow(_ indexPath:IndexPath){
        tableViewDatum.insertRows(at: [indexPath], with: .bottom)
        if let v = tableViewDatum.indexPathsForVisibleRows?.last?.row{
            if indexPath.row > v  {
                tableViewDatum.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
            
        }
        
    }

    @objc func scrollToBottom(){
        if let x = tabelData{
            tableViewDatum.layoutIfNeeded()
            let lastIndex = NSIndexPath(row: x.oldTableEntries.count - 1, section: 0)
            tableViewDatum.scrollToRow(at: lastIndex as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)}
    }
    
    func checkForBackgroundForeground()
    {
        //    if !(UIDevice.current.isBatteryMonitoringEnabled){UIDevice.current.isBatteryMonitoringEnabled = true}
        //   Foreground()
        
        //    NotificationCenter.default.addObserver(self, selector: #selector(visiteVC.startZoekLocatieBijContacten),name:NSNotification.Name("zoekLocatieBijContacten"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList),name:NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.Foreground),name:NSNotification.Name(rawValue: "Foreground"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollToBottom),name:NSNotification.Name(rawValue: "scrollToBottom"), object: nil)
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
