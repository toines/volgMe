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
        tabelData?.expandMaanden()
        print ("---")
        print (tabelData?.kalender  ?? "")

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

}
@IBDesignable
class StackView: UIStackView {
    @IBInspectable private var color: UIColor?
    override var backgroundColor: UIColor? {
        get { return color }
        set {
            color = newValue
            self.setNeedsLayout() // EDIT 2017-02-03 thank you @BruceLiu
        }
    }
    
    private lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.path = UIBezierPath(rect: self.bounds).cgPath
        backgroundLayer.fillColor = self.backgroundColor?.cgColor
    }
}
