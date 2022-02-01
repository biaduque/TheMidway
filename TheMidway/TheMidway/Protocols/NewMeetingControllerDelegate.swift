//
//  NewMeetingControllerDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 31/01/22.
//


protocol NewMeetingControllerDelegate: AnyObject {
    func setParticipantsAction() -> Void
    func getParticipants(by participants: ParticipantsSelected) -> Void
}
