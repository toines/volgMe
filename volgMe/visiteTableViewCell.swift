//
//  visiteTableViewCell.swift
//  volgMe
//
//  Created by Toine Schnabel on 10/10/2018.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import UIKit

class visiteTableViewCell: UITableViewCell {
    @IBOutlet var van: UILabel!
    @IBOutlet var tot: UILabel!
    @IBOutlet var straat: UILabel!
    @IBOutlet var stad: UILabel!
    @IBOutlet var naam: UILabel!
    
    var selectedDate = Date_70()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func vulVisiteCell(forDatum : Date_70,visite: String)
    {
        selectedDate = forDatum
        if let x = fetchBezoek(datum: forDatum) {
            if x.arrivalDate.dd == visite.suffix(2) {van.text = x.arrivalDate.hh_mm()} else {van.text = "....."}
            if x.departureDate.dd == visite.suffix(2) {tot.text = x.departureDate.hh_mm()} else {tot.text = "....."}
            if let y = x.metAdres
            {
                stad.text = y.stad
                naam.text = y.naam
                straat.text = y.straatHuisnummer
            }
        }
        
    }


}
