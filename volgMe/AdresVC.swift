//
//  VisiteVC.swift
//  volgMe
//
//  Created by Toine Schnabel on 17/10/2018.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import UIKit

class AdresVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    @IBOutlet var TableView: UITableView!
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
    @IBOutlet var bLatitude: UILabel!
    @IBOutlet var bLongitude: UILabel!
    
    var changes = false
    var datum: Date_70?
    var visites = [Bezoek(context: context)]
    var soortPlaatsen = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        naam.delegate = self
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "❮ Dagboek", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton

        straatHuisnummer.delegate = self
        provincie.delegate = self
        landCode.delegate = self
        postcode.delegate = self
        plaats.delegate = self
        soortPlaats.delegate = self
        icoon.delegate = self

        TableView.delegate = self
        if soortPlaatsen.count == 0 {soortPlaatsen = ["Kennis","Familie","Camping","Camperplaats","overnachtingsplaats","restaurant","Hotel"]}
        if let x = datum {
            if let bezoek = fetchBezoek(datum: x){
                if let adres = bezoek.metAdres {
                    naam.text = adres.naam
                    provincie.text = adres.provincie
                    straatHuisnummer.text = adres.straatHuisnummer
                    landCode.text = adres.landcode
                    postcode.text = adres.postcode
                    plaats.text = adres.stad
                    soortPlaats.text = adres.soortPlaats
                    icoon.text = adres.icon
                    latitude.text = "lat: \(adres.latitude)"
                    longitude.text = "long: \(adres.longitude)"
                    bLatitude.text = "lat: \(bezoek.latitude)"
                    bLongitude.text = "long: \(bezoek.longitude)"
                    if let x = adres.bezocht {
                        visites = (Array(x) as! [Bezoek])
                        visites = visites.sorted{$0.arrival_1970 < $1.arrival_1970}
                        }
                    }
                }
            }
            
            // Do any additional setup after loading the view.
        }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
  //      if changes {showAlert()}

        if changes {showAlert()}
        else {_ = self.navigationController?.popViewController(animated: true)}
    }
    func saveAdres(){
        if let x = self.datum {
            if let bezoek = fetchBezoek(datum: x){
                if let adres = bezoek.metAdres {
                    
                    adres.naam = naam.text
                    adres.provincie = provincie.text
                    adres.straatHuisnummer = straatHuisnummer.text
                    adres.landcode = landCode.text
                    adres.postcode = postcode.text
                    adres.stad = plaats.text
                    adres.soortPlaats = soortPlaats.text
                    adres.icon = icoon.text
                    delegate.saveContext()
                    NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
                }
            }
        }
    }
    func showAlert() {
        let alertController = UIAlertController(title: "Text has changed", message: "Do you want to save.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction!) in
            self.saveAdres()
            _ = self.navigationController?.popViewController(animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler:{ (action: UIAlertAction!) in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        
        present(alertController, animated: true, completion: nil)
    }

        func numberOfSections(in tableView: UITableView) -> Int { return 1}

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let cell = tableView.dequeueReusableCell(withIdentifier: "adresHeader",for: IndexPath(row: 0, section: section)) as! AdresHeaderCell
            cell.titel.text = "\(visites.count) keer bezocht"
            return cell
    }

    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return visites.count
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "adresBezoek",for: IndexPath(row: indexPath.row, section: indexPath.section)) as! adresBezoekTableViewCell
            cell.van.text = "van: \(visites[indexPath.row].arrivalDate.yyyy_MM_dd_HH_mm_ss)"
        cell.tot.text = "tot:\(visites[indexPath.row].departureDate.yyyy_MM_dd_HH_mm_ss)"
            return cell
        }
        
        //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return UITableViewCell()
        //    }
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
//        func NavigatieKnoppen()
//        {
//            let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(save))
//            let play = UIBarButtonItem(title: "Play", style: .plain, target: self, action: #selector(save))
//            
//            navigationItem.rightBarButtonItems = [add, play]
//            
//        }
    var origineleWaarde = ""
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("\(textField) TextField did begin editing method called")
        origineleWaarde = textField.text ?? ""
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        textField.textColor = UIColor.gray
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("\(textField) TextField did end editing method called")
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("\(textField) TextField should begin editing method called")
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("TextField should snd editing method called")
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        return true
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == origineleWaarde {textField.textColor = UIColor.black
            ErrMsg("veld gewijzigd", .debug, #function)   }
        else {textField.textColor = UIColor.blue; changes = true}
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
}


