//
//  CNContactDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 28/01/22.
//

import Foundation
import Contacts
import ContactsUI

class CNContactDelegate: NSObject, CNContactPickerDelegate {
    
    /* MARK: - Atributos */
    
    private var peopleSelected: [String:ContactInfo] = [:]
    
    private var parentController: ParticipantsViewController!
    
    
    
    /* MARK: - Encapsulamento */
    
    public func getPeopleSelected() -> [ContactInfo] {
        return Array(self.peopleSelected.values)
    }
    
    
    public func setParentController(_ vc: ParticipantsViewController) -> Void {
        self.parentController = vc
    }
    
    
    
    /* MARK: - Delegate */
    
    /// Pega os contatos selecionados
    public func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) -> Void {
        for contact in contacts {
            let contactInfo = self.getContactInfo(with: contact)
        
            if !(self.peopleSelected.keys.contains(contactInfo.name)) {
                self.peopleSelected[contactInfo.name] = contactInfo
            }
        }
        self.parentController.verifyContactAddress(self.getPeopleSelected())
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Pega as infomações da lista de contatos
    public func getContactInfo(with contact: CNContact) -> ContactInfo {
        
        let postalInfo: [CNLabeledValue<CNPostalAddress>] = contact.postalAddresses
        
        let name: String = "\(contact.givenName) \(contact.familyName)"
        
        // Verifica se tem informações nos campos de endereço
        if postalInfo.count != 0 {
            let infos = postalInfo[0].value

            let address = AddressInfo(
                postalCode: infos.postalCode,
                country: infos.country,
                city: infos.isoCountryCode,
                district: infos.subLocality,
                address: infos.street,
                number: ""
            )
            return ContactInfo(name: name, contact: contact, address: address)
        }
        return ContactInfo(name: name, contact: contact)
    }
}
