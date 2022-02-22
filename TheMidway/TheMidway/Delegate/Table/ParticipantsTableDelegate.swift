//
//  ParticipantsTableDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 29/01/22.
//

import UIKit
import Contacts
import ContactsUI

class ParticipantsTableDelegate: NSObject, UITableViewDelegate {
    
    /* MARK: - Atributos */
    
    private var person: [Person] = []
    
    private weak var participantsDelegate: ParticipantsControllerDelegate!
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setPerson(_ person: [Person]) -> Void {
        return self.person = person
    }
    
    public func setDelegate(_ delegate: ParticipantsControllerDelegate) -> Void {
        self.participantsDelegate = delegate
    }
    
    
    
    /* MARK: - Delegate */
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
        
        
        let personContact = self.person[indexPath.row]
        
        self.participantsDelegate.openContactPage(with: personContact)
        tableView.tag = indexPath.row
    }
}
