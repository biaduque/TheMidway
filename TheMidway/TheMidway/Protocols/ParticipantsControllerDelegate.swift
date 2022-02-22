//
//  ParticipantsControllerDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 01/02/22.
//

import Contacts


protocol ParticipantsControllerDelegate: AnyObject {
    func openContactPage(with contact: Person) -> Void
}
