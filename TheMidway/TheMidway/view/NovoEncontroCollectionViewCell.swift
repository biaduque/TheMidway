//
//  NovoEncontroCollectionViewCell.swift
//  TheMidway
//
//  Created by Beatriz Duque on 25/11/21.
//

import UIKit

class NovoEncontroCollectionViewCell: UICollectionViewCell {
    
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
    public func stylize(nearbyPlace: MapPlace){
        self.backgroundColor = UIColor(named: "BackgroundColor")!
        self.layer.cornerRadius = 5
        
        labelTitulo.text = nearbyPlace.name
        //labelEndereco.text = String(nearbyPlace.address)
    }
    
    public func teste(){
        self.backgroundColor = UIColor(named: "BackgroundColor")!
        self.layer.cornerRadius = 5
        labelTitulo.text = "Oiii"
    }
}
