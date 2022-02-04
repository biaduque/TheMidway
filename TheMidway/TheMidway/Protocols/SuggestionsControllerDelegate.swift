//
//  SuggestionsControllerDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 03/02/22.
//

import class UIKit.UIButton


protocol SuggestionsControllerDelegate: AnyObject {
    func reloadCollectionData() -> Void
    func getSuggestionsPlaces() -> [MapPlace]
    func createNewMeeting(with place: MapPlace) -> Void
    func setWebButtonAction(_ button: UIButton) -> Void
}
