//
//  NewMeetingControllerDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 31/01/22.
//

import class UIKit.UIButton


protocol NewMeetingControllerDelegate: AnyObject {
    func setParticipantsAction() -> Void
    func getParticipants(by participants: ParticipantsSelected) -> Void
    func setWebButtonAction(_ button: UIButton) -> Void
}
