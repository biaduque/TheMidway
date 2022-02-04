//
//  ParticipantsTableDataSource.swift
//  TheMidway
//
//  Created by Gui Reis on 29/01/22.
//

import UIKit

class ParticipantsTableDataSource: NSObject, UITableViewDataSource {
    
    /* MARK: - Atributos */
    
    private var person: [Person] = []
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setPerson(_ person: [Person]) -> Void {
        return self.person = person
    }
    
    
    
    /* MARK: - Data Sources */
    
    /// Fala quantas linhas vão ter na tableView
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.person.count
    }
    
    
    /// Cria o conteúdo da célula
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Cria uma variável para mexer com uma célula que foi criada
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ParticipantsTableCell.identifier, for: indexPath) as? ParticipantsTableCell else {
            return ParticipantsTableCell()
        }
        
        let person = self.person[indexPath.row]
        
        var completeAddres = NewMeetingViewController.creatAddressVisualization(place: person.contactInfo.address)
        
        if completeAddres == "" {
            completeAddres = "Endereço não encontrado. Clique para atualizar o endereço do contato."
        }
        
        cell.setCellTitle(
            titleText: LabelConfig(text: person.contactInfo.name, sizeFont: 18, weight: .semibold),
            subtitleText:LabelConfig(text: completeAddres, sizeFont: 13, weight: .regular),
            image: person.image
        )

        return cell
    }
}
