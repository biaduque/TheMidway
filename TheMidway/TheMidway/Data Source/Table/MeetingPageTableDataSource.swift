//
//  MeetingPageTableDataSource.swift
//  TheMidway
//
//  Created by Gui Reis on 02/02/22.
//

import UIKit

class MeetingPageTableDataSource: NSObject, UITableViewDataSource {
    
    /* MARK: - Atributos */
    
    private var meetingPageProtocol: MeetingPageViewControllerDelegate!
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setProtocol(_ delegate: MeetingPageViewControllerDelegate) -> Void {
        self.meetingPageProtocol = delegate
    }
    
    
    
    /* MARK: - Data Sources */
    
    /// Fala quantas linhas vão ter na tableView
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meetingPageProtocol.getParticipants().count
    }
    
    
    /// Cria o conteúdo da célula
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Cria uma variável para mexer com uma célula que foi criada
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MeetingPageTableCell.identifier, for: indexPath) as? MeetingPageTableCell else {
            return MeetingPageTableCell()
        }
        
        let info = self.meetingPageProtocol.getParticipants()
        
        cell.setCellInfo(
            image: info[indexPath.row].image,
            name: LabelConfig(text: info[indexPath.row].name, sizeFont: 20, weight: .semibold),
            distance: LabelConfig(text: info[indexPath.row].distance, sizeFont: 15, weight: .medium)
        )
        
        return cell
    }
}
