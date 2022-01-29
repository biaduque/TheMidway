//
//  NewMeetingFormsTableDataSource.swift
//  TheMidway
//
//  Created by Gui Reis on 27/01/22.
//

import UIKit

class NewMeetingFormsTableDataSource: NSObject, UITableViewDataSource {
    
    /* MARK: - Atributos */
    
    private var textFieldDelegate = TextFieldDelegate()
    
    
    
    /* MARK: - Data Source */
    
    /// Quantidade de células que vai ter na table
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        return 3
    }
    
    
    /// Número de sessões diferentes
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    /// Cria o conteúdo da célula
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if indexPath.section == 0 {
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: NewMeetingTableTitleCell.identifier, for: indexPath) as? NewMeetingTableTitleCell else {
                return cell
            }
            
            newCell.setTextBackground("Título do encontro")
            newCell.setTextFieldDelegate(delegate: self.textFieldDelegate)
            cell = newCell
        } else {
            switch indexPath.row {
            case 0:
                guard let newCell = tableView.dequeueReusableCell(withIdentifier: NewMeetingTableDateCell.identifier, for: indexPath) as? NewMeetingTableDateCell else {
                    return cell
                }
                
                newCell.setCellTitle(LabelConfig(text: "Quando será?", sizeFont: 17, weight: .bold))
                cell = newCell
                
            case 1:
                guard let newCell = tableView.dequeueReusableCell(withIdentifier: NewMeetingTableParticipantsCell.identifier, for: indexPath) as? NewMeetingTableParticipantsCell else {
                    return cell
                }
                
                newCell.setCellTitle(
                    leftText: LabelConfig(text: "Quem vai?", sizeFont: 17, weight: .bold),
                    rightText: LabelConfig(text: "10", sizeFont: 17, weight: .regular))
                cell = newCell

            default: return cell
            }
        }
    
        return cell
    }
}
