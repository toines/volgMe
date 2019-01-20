//
//  SearchTableViewCell.swift
//  volgMe
//
//  Created by Toine Schnabel on 16/10/2018.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet var datum: UILabel!
    @IBOutlet var vanTot: UILabel!
    @IBOutlet var straat: UILabel!
    @IBOutlet var stad: UILabel!
    @IBOutlet var provincie: UILabel!
    @IBOutlet var naam: UILabel!
    @IBOutlet var vlag: UILabel!
    @IBOutlet var postcode: UILabel!
    var selectedDate = Date_70()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func vulZoekCell(datum:Date_70){
        if let x = fetchBezoek(datum: datum) {
            selectedDate = datum
            vanTot.text = "\(x.arrivalDate.hh_mm())-\(x.departureDate.hh_mm())"
            self.datum.text = "\(datum.date.d_M_yyyy)"
            if let y = x.metAdres
            {
                stad.text = y.stad
                naam.text = y.naam
                //               cell.provincie.text = y.provincie
                postcode.text = y.postcode
                straat.text = y.straatHuisnummer
                vlag.text = landCodeToFlag(landcode: y.landcode ?? "")
            }
        }
    }

}
