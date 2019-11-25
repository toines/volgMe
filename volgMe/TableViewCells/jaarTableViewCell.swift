//
//  jaarTableViewCell.swift
//  volgMe
//
//  Created by Toine Schnabel on 24/11/2019.
//  Copyright © 2019 Toine Schnabel. All rights reserved.
//

import Foundation

import UIKit

class jaarTableViewCell: UITableViewCell {
    func geselecteerd() {
// //       print ("\(self.knop.title(for: .normal) ?? "")")
//        if let x = self.knop {tabelData!.handleDagenVoor(maand:x)}
////        NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
    }
    @IBOutlet var jaar: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func vulJaarCell(maand:String){
//        var x = ""
//        for plaats in tabelData?.datumDictionary[maand]?.plaatsen ?? Set<String>() {x = x + "\(plaats) " }
//        landen.text = "\(x)"
//        jaar.text = String(maand.prefix(4))
//        self.maand.text = maand.toDate().MMMM
//        knop = maand
    }
}
