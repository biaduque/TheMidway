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
    
    private var mainProtocol: MainControllerDelegate!
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setProtocol(_ delegate: MainControllerDelegate) -> Void {
        self.mainProtocol = delegate
    }
    
    
    
    /* MARK: - Data Sources */
    
    /// Fala quantas linhas vão ter na tableView
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainProtocol.getMeeting().count
    }
    
    
    /// Cria o conteúdo da célula
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Cria uma variável para mexer com uma célula que foi criada
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainViewTableCell.identifier, for: indexPath) as? MainViewTableCell else {
            return MainViewTableCell()
        }
        
        let allMeetings = self.mainProtocol.getMeeting()
        
        let meetingId = Int(allMeetings[indexPath.row].id)

        let participantsAtMeeting = ParticipantsCDManeger.shared.getParticipants(at: meetingId)
        
        var participantsName: [String] = []
        
        
        for person in participantsAtMeeting {
            participantsName.append(person.name ?? "")
        }
        
        let infos = MeetingCreatedCellInfo(
            title: LabelConfig(
                text: allMeetings[indexPath.row].meetingName ?? "",
                sizeFont: 20, weight: .bold
            ),
            date: LabelConfig(
                text: allMeetings[indexPath.row].date ?? "",
                sizeFont: 14, weight: .regular
            ),
            hour: allMeetings[indexPath.row].hour ?? "",
            participants: participantsName,
            participantsConfig: LabelConfig(text: "", sizeFont: 11, weight: .regular)
        )

        cell.setCellInfo(info: infos)
        return cell
    }
}
