//
//  SetupVC.swift
//  volgMe
//
//  Created by Toine Schnabel on 03/11/2018.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import UIKit
import MessageUI

class SetupVC: UIViewController,MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func upload(_ sender: Any) {
        do {
            let records = try context.fetch(Bezoek.fetchRequest()) as [Bezoek]
            
            //           let jsonString = String(data: records, encoding: .utf8)
            let jsonBezoekData = try JSONEncoder().encode(records)
            let jsonBezoekString = String(data: jsonBezoekData, encoding: .utf8)
            let adressen = try context.fetch(Adres.fetchRequest()) as [Adres]
            let jsonAdresData = try JSONEncoder().encode(adressen)
            let jsonAdresString = String(data: jsonAdresData, encoding: .utf8)
 //           print("bezoeken : \(jsonBezoekString ?? ""), adressen : \(jsonAdresString ?? "")")
            sendMail(attachmentVisites: [jsonBezoekData,jsonAdresData])
            //            print ("json   \(jsonData)")
        } catch {
            print("Error fetching data from CoreData")
        }

    }
    func sendMail(attachmentVisites:([Data]))
    {
        let mailComposeViewController = configuredMailComposeViewController(attachmentVisites:attachmentVisites[0])
            mailComposeViewController.addAttachmentData(attachmentVisites[1], mimeType: "json",              fileName: "adressen")
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showAlert()
        }
        
    }
    func configuredMailComposeViewController(attachmentVisites:(Data)) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["twan.schnabel@gmail.com"])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        mailComposerVC.addAttachmentData(attachmentVisites, mimeType: "json", fileName: "visits")
        //       mailComposerVC.addAttachmentData(attachmentVisites.1, mimeType: "log", fileName: "locaties")
        return mailComposerVC
    }
    func showAlert() {
        let alertController = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
