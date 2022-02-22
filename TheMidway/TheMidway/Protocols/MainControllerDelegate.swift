//
//  MainControllerDelegate.swift
//  TheMidway
//
//  Created by Leticia Utsunomiya on 01/02/22.
//


protocol MainControllerDelegate: AnyObject {
    func openSuggestionsAction(name: String) -> Void
    func openMeetingPageAction(meetingInfo: MeetingCompleteInfo) -> Void
    func reloadMeetingsTableData() -> Void
    func getMeeting() -> [Meetings]
    func deleteMeeting(with meeting: Meetings) -> Void
}
