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
    
    private var placesFound: [MapPlace] = []
    
    private let contactController = CNContactPickerViewController()
    
    private var parentController: UIViewController!
    
    

    
    /* MARK: - Encapsulamento */
    
    public func setPlacesFound(_ places: [MapPlace]) -> Void {
        return self.placesFound = places
    }
    
    public func setContactControllerDelegate(_ delegate: CNContactDelegate) -> Void {
        self.contactController.delegate = delegate
    }
    
    public func setParentController(_ vc: UIViewController) -> Void {
        self.parentController = vc
    }
    
    
    /* MARK: - Delegate */
    
    /// Ação de quando clica em uma célula
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
        
        // Células dos participantes
        if indexPath.section == 1 && indexPath.row == 1 {
            self.contactController.navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Teste", style: .done, target: self.parentController, action: #selector(self.okAction))
            
            self.parentController.modalPresentationStyle = .popover
            self.parentController.present(self.contactController, animated: true)
        }
    }
    
    @objc private func okAction() -> Void {
        print("Entrei na função do botão")
    }
}
