//
//  AmigosCollectionViewCell.swift
//  TheMidway
//
//  Created by Beatriz Duque on 15/12/21.
//

import UIKit

class AmigosCollectionViewCell: UICollectionViewCell {
    let colors = ["Color1Principal","Color2Principal","Color3Principal","Color4Principal"]

    @IBOutlet weak var nomeAmigoLabel: UILabel!
    
    func stylize(nome: String){
        nomeAmigoLabel.text = nome
        nomeAmigoLabel.backgroundColor = UIColor(named: colors[Int.random(in: 0..<colors.count)])?.withAlphaComponent(0.5)
        nomeAmigoLabel.layer.cornerRadius = 5
        self.layer.cornerRadius = 5
    }
}
