//
//  NewMeetingFormsTableDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 27/01/22.
//

import UIKit
import CoreData
import ContactsUI

class NewMeetingFormsTableDelegate: NSObject, UITableViewDelegate {
    
    /* MARK: - Atributos */
    
    private var parentController: NewMeetingViewController!
    
    

    /* MARK: - Encapsulamento */
    
    public func setParentController(_ vc: NewMeetingViewController) -> Void {
        self.parentController = vc
    }
    
    
    
    /* MARK: - Delegate */
    
    /// Ação de quando clica em uma célula
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
        
        // Células dos participantes
        if indexPath.section == 1 && indexPath.row == 1 {
            self.parentController.setParticipantsAction()
        }
    }
}
