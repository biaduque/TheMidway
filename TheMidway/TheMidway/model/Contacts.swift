//
//  Contacts.swift
//  TheMidway
//
//  Created by Beatriz Duque on 01/12/21.
//

import Foundation
import UIKit
import Contacts

class Contacts {
    static let shared:Contacts = Contacts()
    public func fatchContacts() ->[PessoaBase]{
        var contacts = [PessoaBase]()
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) {(granted, err) in
            if let err = err {
                print("Falha ao acessar os contatos: ", err)
                return
            }
            if granted {
                ///se a pessoa aceitou o acesso aos contatos
                let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPostalAddressesKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    try store.enumerateContacts(with: request, usingBlock: {
                        (contact, stopPointerIfYouWantToStopEnumerating) in
                        //print(contact.givenName)
                        //print(contact.postalAddresses[0].value.street)
                        contacts.append(PessoaBase(nome: contact.givenName + " " + contact.familyName, endereco: self.getString(postalAdress: contact.postalAddresses), icone: ""))
                    })
                } catch let err {
                    print("Falha ao enumerar os contatos:",err)
                }
                
            }else{
                //se a pessoa nao aceitou o acesso aos contatos
                print("Solicitacao de acesso negada")
            }
        }
        let sortedArray =  contacts.sorted(by: { $0.nome < $1.nome })
        return sortedArray
        
    }
    
    ///funcao utilizada para transformar o endereco postal em string 
    private func getString(postalAdress: [CNLabeledValue<CNPostalAddress>]) -> String{
        var string = postalAdress[0].value.street
        string = string + "," + postalAdress[0].value.subLocality
        string = string + postalAdress[0].value.city
        string = string + "-" + postalAdress[0].value.state
        string  = string + "," + postalAdress[0].value.country
        return string
    }
}
