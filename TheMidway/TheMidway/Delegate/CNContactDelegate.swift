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
    
    /* MARK: - Atriutos */
    
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
    
    /// Pega os conttos selecionados
    public func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) -> Void {
        print("\n\nPessoas selecionadas da lista: \(contacts.count)\n\n")
        
        for contact in contacts {
            let postalInfo: [CNLabeledValue<CNPostalAddress>] = contact.postalAddresses

            // Verifica se tem informações nos campos de endereço
            if postalInfo.count != 0 {
                let infos = postalInfo[0].value

                let name: String = "\(contact.givenName) \(contact.familyName)"
                
                let address = AddressInfo(
                    postalCode: infos.postalCode,
                    country: infos.country,
                    city: infos.isoCountryCode,
                    district: infos.subLocality,
                    address: infos.street,
                    number: ""
                )
                
                let contactInfo = ContactInfo(name: name, address: address)
                
                if !(self.peopleSelected.keys.contains(name)) {
                    self.peopleSelected[name] = contactInfo
                }
                
                self.showContactInfo(contact: contactInfo)
            }
        }
        print("\n\nPessoas selecionadas: \(self.peopleSelected.count)\n\n")
        
        
        self.parentController.verifyContactAddress(self.getPeopleSelected())
    }
    
    
    
    /* MARK: - Outros */
    
    private func showContactInfo(contact: ContactInfo) -> Void {
        print("Nome: \(contact.name)\n")
        print("Pais: \(contact.address.country)")
        print("Cidade: \(contact.address.city)")
        print("Bairro: \(contact.address.district)")
        print("CEP: \(contact.address.postalCode)")
        print("Rua: \(contact.address.address)")
    }
}
