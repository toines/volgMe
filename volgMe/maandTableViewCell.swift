//
//  maandTableViewCell.swift
//  volgMe
//
//  Created by Toine Schnabel on 10/10/2018.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import UIKit

class maandTableViewCell: UITableViewCell {
    @IBOutlet var knop: UIButton!
    @IBAction func geselecteerd(_ sender: Any) {
        print ("\(self.knop.title(for: .normal) ?? "")")
        if let x = self.knop.title(for: .normal) {tabelData!.handleDagenVoor(maand:x)}
        NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
    }
    @IBOutlet var jaar: UILabel!
    @IBOutlet var maand: UILabel!
    @IBOutlet var landen: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func vulMaandCell(maand:String){
        var x = ""
        for plaats in tabelData?.datumDictionary[maand]?.plaatsen ?? Set<String>() {x = x + "\(plaats) " }
        landen.text = "\(x)"
        jaar.text = String(maand.prefix(4))
        self.maand.text = maand.toDate().MMMM
        knop.setTitle(maand, for: .normal)
    }

}


