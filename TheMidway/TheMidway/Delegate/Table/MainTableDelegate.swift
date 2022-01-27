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
    
    private var meetings: [Meetings] = []
    
    
    
    /* MARK: -  */
    
    init(meetings: [Meetings]) {
        self.meetings = meetings
        
        super.init()
    }
    
    
    
    /* MARK: - Delegate */
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
        print("Cell pressed")
    }
}
