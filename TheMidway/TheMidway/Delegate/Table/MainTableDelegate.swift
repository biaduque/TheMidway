//
//  MainTableDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 26/01/22.
//

import UIKit
import CoreData

class MainTableDelegate: NSObject, UITableViewDelegate {
    
    /* MARK: - Atributos */
    
    private var mainProtocol: MainControllerDelegate!
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setProtocol(_ delegate: MainControllerDelegate) -> Void {
        self.mainProtocol = delegate
    }
    
    
    
    /* MARK: - Delegate */
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
        
        let meetingSelected: Meetings = self.mainProtocol.getMeeting()[indexPath.row]
        let participants: [Participants] = ParticipantsCDManeger.shared.getParticipants(at: Int(meetingSelected.id))
        
        let meetingInfo = MeetingCompleteInfo(meeting: meetingSelected, participants: participants)
        
        self.mainProtocol.openMeetingPageAction(meetingInfo: meetingInfo)
    }
    
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: nil) {_, _, handler in
            handler(true)
            
            let allMeetings = self.mainProtocol.getMeeting()
            self.mainProtocol.deleteMeeting(with: allMeetings[indexPath.row])
        }
        action.image = UIImage(systemName: "trash")
        action.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
        
    }
}
