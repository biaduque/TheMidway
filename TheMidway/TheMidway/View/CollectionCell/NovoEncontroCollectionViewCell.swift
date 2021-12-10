//
//  NovoEncontroCollectionViewCell.swift
//  TheMidway
//
//  Created by Beatriz Duque on 25/11/21.
//

import UIKit

protocol NovoEncontroCollectionViewCellDelegate: AnyObject{
    func newLocation(nearbyPlace: MapPlace)
}

class NovoEncontroCollectionViewCell: UICollectionViewCell {
    let colors = ["Color1","Color2","Color3","Color4"]
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelEndereco: UILabel!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    var nearbyPlace: MapPlace?
    
    weak var delegate: NovoEncontroCollectionViewCellDelegate?
    
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
        self.nearbyPlace = nearbyPlace
        self.backgroundColor = UIColor(named: "BackgroundColor")!
        self.layer.cornerRadius = 5
        //self.labelEndereco.text = "Rua Antonio Alves de Souza, 22"
        
        ///edicao da tag de tipos
        self.tagView.backgroundColor = UIColor(named: colors[Int.random(in: 0..<colors.count)])
        self.tagView.layer.cornerRadius = 3
        labelTitulo.text = nearbyPlace.name
        //labelEndereco.text = String(nearbyPlace.address)
    }
    @IBAction func clickCheck(_ sender: Any) {
        if checkButton.imageView?.image == UIImage(systemName: "circle"){
            checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
        else{
            checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        delegate?.newLocation(nearbyPlace: self.nearbyPlace!)
    }
}
