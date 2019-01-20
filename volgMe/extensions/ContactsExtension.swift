//
//  ContactsExtension.swift
//  volgMe
//
//  Created by Toine Schnabel on 24-09-18.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import Foundation
import Contacts
import UIKit

var contactStore : CNContactStore?

func StoreAllContactsAdresses() // ->[String]
{   let contactStore = CNContactStore()
    var contacts = [CNContact]()
    let keys = [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
        CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPostalAddressesKey] as! [CNKeyDescriptor]
    let request = CNContactFetchRequest(keysToFetch: keys)
    do {try contactStore.enumerateContacts(with: request){
        (contact, stop) in
        // Array containing all unified contacts from everywhere
        contacts.append(contact)
        for adres in contact.postalAddresses {
            print("\(contact.givenName) \(contact.familyName) \(adres.value.street) \(adres.value.postalCode) \(adres.value.state) \(adres.value.city) \(adres.value.isoCountryCode)")
            let adrInfo = Adres(context: context)
            adrInfo.naam = "\(contact.givenName) \(contact.familyName)"
            adrInfo.landcode = adres.value.isoCountryCode
            adrInfo.stad = adres.value.city
            adrInfo.straatHuisnummer = adres.value.street
            adrInfo.postcode = adres.value.postalCode
            delegate.saveContext()
        }
        }
        //       print(contacts)
    } catch {
        print("unable to fetch contacts")
    }
}
