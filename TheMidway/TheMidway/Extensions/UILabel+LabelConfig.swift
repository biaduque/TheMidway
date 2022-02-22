//
//  UILabel+TextConfig.swift
//  TheMidway
//
//  Created by Gui Reis on 03/02/22.
//

import UIKit


extension UILabel {
    
    internal func configureLabelText(with config: LabelConfig) -> Void {
        self.text = config.text
        self.font = .systemFont(ofSize: config.sizeFont, weight: config.weight)
    }
}
