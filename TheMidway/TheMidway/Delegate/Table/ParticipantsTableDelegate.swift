//
//  ParticipantsTableDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 29/01/22.
//

import UIKit

class ParticipantsTableDelegate: NSObject, UITableViewDelegate {
    
    /* MARK: - Atributos */
    
    private var person: [Person] = []
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setPerson(_ person: [Person]) -> Void {
        return self.person = person
    }
    
    
    
    /* MARK: - Delegate */
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            print("Vai abrir uma nova controller aqui")
        }
    }
}
