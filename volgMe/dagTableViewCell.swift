//
//  dagTableViewCell.swift
//  volgMe
//
//  Created by Toine Schnabel on 10/10/2018.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import UIKit

class dagTableViewCell: UITableViewCell {
    
    @IBOutlet var dagStackView: UIStackView!
    @IBOutlet var knop: UIButton!
    @IBAction func geselecteerd(_ sender: Any) {
        print ("\(self.knop.title(for: .normal) ?? "")")
        if let x = self.knop.title(for: .normal) {tabelData!.handleVisitesVoor(dag:x)}
        NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
        
    }

    
    @IBOutlet var datum: UILabel!
    @IBOutlet var stad: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func vulDagCell(dag:String){
        var x = ""
        if let y = tabelData?.datumDictionary[dag]?.plaatsen {
            for plaats in y {x = x + "\(plaats) " }
        }
        stad.text = x
        datum.text = "\(dag.toDate().EEEE()) : \(dag.toDate().d_MMMM_yyyy)"
        knop.setTitle(dag, for: .normal)
        //        cell.dag.text = dag.toDate().EEEE()
    }


}
