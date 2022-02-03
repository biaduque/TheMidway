//
//  SuggestionsCollectionCell.swift
//  TheMidway
//
//  Created by Gui Reis on 03/02/22.
//

import UIKit

class SuggestionsCollectionCell: NewMeetingCollectionCell {
    
    /* MARK: -  */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.checkButton.isHidden = false
        self.tagLabel.isHidden = false
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
