//
//  UIImageView+LabelConfig.swift
//  TheMidway
//
//  Created by Gui Reis on 04/02/22.
//

import UIKit


extension UIImageView {
    
    internal func setImage(with config: LabelConfig) -> Void {
        let weight = UIImage.SymbolWeight(rawValue: Int(config.weight.rawValue)) ?? .medium
        let configIcon = UIImage.SymbolConfiguration(pointSize: config.sizeFont, weight: weight, scale: .large)
        
        self.image = UIImage(systemName: config.text, withConfiguration: configIcon)
    }
}
