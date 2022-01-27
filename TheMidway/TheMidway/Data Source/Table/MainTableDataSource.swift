//
//  MainTableDataSource.swift
//  TheMidway
//
//  Created by Gui Reis on 26/01/22.
//

import UIKit
import CoreData

class MainTableDataSource: NSObject, UITableViewDataSource {
    
    /* MARK: - Atributos */
    
    private var meetings: [Meetings] = []
    
    
    
    /* MARK: -  */
    
    init(meetings: [Meetings]) {
        self.meetings = meetings
        
        super.init()
    }
    
    
    
    /* MARK: - Data Sources */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meetings.count
    }
    
    
    /// Cria o conteúdo da célula
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Cria uma variável para mexer com uma célula que foi criada
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainViewTableCell.identifier, for: indexPath) as? MainViewTableCell else {
            return MainViewTableCell()
        }
        
        let infos = MeetingCreatedCellInfo(
            title: LabelConfig(
                text: self.meetings[indexPath.row].meetingName ?? "",
                sizeFont: 20, weight: .bold
            ),
            date: LabelConfig(
                text: self.meetings[indexPath.row].date ?? "",
                sizeFont: 14, weight: .regular
            ),
            hour: self.meetings[indexPath.row].hour ?? "",
            participants: ["Gui", "Anna", "Leh", "Bia", "Muza"],
            participantsConfig: LabelConfig(text: "", sizeFont: 11, weight: .regular)
        )

        cell.setCellInfo(info: infos)

        return cell
    }
}
