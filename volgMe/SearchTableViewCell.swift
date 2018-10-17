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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
