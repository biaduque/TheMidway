//
//  CalendarEventDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 02/02/22.
//

import EventKitUI


class CalendarEventDelegate: NSObject, EKEventEditViewDelegate {
    
    /* MARK: - Delegate */
    
    public func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) -> Void {
        controller.dismiss(animated: true)
    }
}
