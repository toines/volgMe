//
//  GemisteVisiteCell.swift
//  volgMe
//
//  Created by Toine Schnabel on 26/01/2019.
//  Copyright © 2019 Toine Schnabel. All rights reserved.
//

import UIKit

class GemisteVisiteCell: UITableViewCell {

    @IBOutlet weak var labelAankomst: UILabel!
    @IBOutlet weak var labelVertrek: UILabel!
    @IBOutlet weak var textfieldVertrek: UITextField!
    @IBOutlet weak var textfieldAankomst: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
