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
        
        if indexPath.section == 1 && indexPath.row == 1 {
            print("Vai abrir uma nova controller aqui")
        }
    }
}
