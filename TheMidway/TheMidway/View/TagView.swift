//
//  TagView.swift
//  TheMidway
//
//  Created by Beatriz Duque on 15/12/21.
//

import UIKit

class TagView: UIView {
    func stilyze(categoria: String){
        self.layer.cornerRadius = 3
        self.backgroundColor = UIColor(named: categoria)
    }
}
