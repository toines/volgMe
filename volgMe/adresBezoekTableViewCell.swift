//
//  adresBezoekTableViewCell.swift
//  volgMe
//
//  Created by Toine Schnabel on 19/10/2018.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import UIKit

class adresBezoekTableViewCell: UITableViewCell {
    @IBOutlet var van: UILabel!
    @IBOutlet var tot: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
