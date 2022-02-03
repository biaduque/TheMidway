//
//  MeetingPageTableDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 02/02/22.
//

import UIKit

class MeetingPageTableDelegate: NSObject, UITableViewDelegate {
    
    
    /* MARK: - Delegate */
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
    }
}
