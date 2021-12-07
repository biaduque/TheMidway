//
//  DataView.swift
//  TheMidway
//
//  Created by Beatriz Duque on 07/12/21.
//

import UIKit

class DataView: UILabel {
    public func style(dataEncontro: Date){
        let formatter =  DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        self.text = formatter.string(from: dataEncontro)
    }
}
