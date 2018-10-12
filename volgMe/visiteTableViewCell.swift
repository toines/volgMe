//
//  visiteTableViewCell.swift
//  volgMe
//
//  Created by Toine Schnabel on 10/10/2018.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import UIKit

class visiteTableViewCell: UITableViewCell {
    @IBOutlet var datum: UILabel!
    @IBOutlet var van: UILabel!
    @IBOutlet var tot: UILabel!
    @IBOutlet var naamOfStraat: UILabel!
    @IBOutlet var stad: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
