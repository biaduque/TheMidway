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
    
    private var meetings: [Meetings] = MeetingCDManeger.shared.getMeetingsCreated()
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setMeetings(_ meetings: [Meetings]) -> Void {
        return self.meetings = meetings
    }
    
    
    
    /* MARK: - Delegate */
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
    }
    
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: nil) {_, _, handler in
            handler(true)
            
            if let _ = try? MeetingCDManeger.shared.deleteMeeting(at: self.meetings[indexPath.row]) {
                self.meetings.remove(at: indexPath.row)
                tableView.reloadInputViews()
                tableView.reloadData()
            }
        }
        action.image = UIImage(systemName: "trash")
        action.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
        
    }
}
