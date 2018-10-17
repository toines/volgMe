//
//  VisiteVC.swift
//  volgMe
//
//  Created by Toine Schnabel on 17/10/2018.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import UIKit

class AdresVC: UIViewController {
    @IBOutlet var naam: UITextField!
    @IBOutlet var straatHuisnummer: UITextField!    
    @IBOutlet var provincie: UITextField!
    @IBOutlet var landCode: UITextField!
    @IBOutlet var postcode: UITextField!
    @IBOutlet var plaats: UITextField!
    @IBOutlet var soortPlaats: UITextField!
    @IBOutlet var icoon: UITextField!
    @IBOutlet var latitude: UILabel!
    @IBOutlet var longitude: UILabel!
    
    var datum: Date_70?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
