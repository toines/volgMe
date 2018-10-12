//
//  dagUitgebreidTableViewCell.swift
//  volgMe
//
//  Created by Toine Schnabel on 11/10/2018.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import UIKit
// class had eigenlijk visiteUitgebreidTableVieCell moeten heten

class dagUitgebreidTableViewCell: UITableViewCell {
    @IBOutlet var arrival: UILabel!
    @IBOutlet var departure: UILabel!
    @IBOutlet var latitude: UILabel!
    @IBOutlet var longitude: UILabel!
    
    @IBOutlet var naam: UITextField!
    @IBOutlet var straat: UITextField!
    @IBOutlet var provincie: UITextField!
    @IBOutlet var landcode: UITextField!
    @IBOutlet var postcode: UITextField!
    @IBOutlet var land: UITextField!
    @IBOutlet var info: UITextField!
    @IBOutlet var icoon: UITextField!
    @IBOutlet var soortPlaats: UITextField!
    @IBOutlet var confirmed: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
