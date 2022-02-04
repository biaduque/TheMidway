//
//  MeetingPageViewControllerDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 02/02/22.
//


protocol MeetingPageViewControllerDelegate: AnyObject {
    func getParticipants() -> [ParticipantInfo]
}
