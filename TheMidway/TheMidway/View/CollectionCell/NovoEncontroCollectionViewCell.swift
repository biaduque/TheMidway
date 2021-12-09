//
//  NovoEncontroCollectionViewCell.swift
//  TheMidway
//
//  Created by Beatriz Duque on 25/11/21.
//

import UIKit

class NovoEncontroCollectionViewCell: UICollectionViewCell {
    let colors = ["Color1","Color2","Color3","Color4"]
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelEndereco: UILabel!
    @IBOutlet weak var tagView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShadow()
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.secondaryLabel.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2.0)
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
    }
    public func stylize(nearbyPlace: MapPlace, endereco: String){
        self.backgroundColor = UIColor(named: "BackgroundColor")!
        self.layer.cornerRadius = 5
        self.labelEndereco.text = "Rua Antonio Alves de Souza, 22"
        
        ///edicao da tag de tipos
        self.tagView.backgroundColor = UIColor(named: colors[Int.random(in: 0..<colors.count)])
        self.tagView.layer.cornerRadius = 3
        labelTitulo.text = nearbyPlace.name
        labelEndereco.text = endereco
    }
}
