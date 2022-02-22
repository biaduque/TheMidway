//
//  ContactInfo.swift
//  TheMidway
//
//  Created by Gui Reis on 28/01/22.
//

import class Contacts.CNContact

struct ContactInfo {
    let name: String
    var contact: CNContact
    var address: AddressInfo
    
    init(name: String, contact: CNContact, address: AddressInfo) {
        self.name = name
        self.contact = contact
        self.address = address
    }
    
    init(name: String, contact: CNContact) {
        self.name = name
        self.contact = contact
        
        self.address = AddressInfo(
            postalCode: "", country: "", city: "", district: "", address: "", number: ""
        )
    }
}
