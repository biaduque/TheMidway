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
    @IBOutlet weak var tagView: TagView!
    @IBOutlet weak var tagLabel: UILabel!
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
        //set de visual
        self.nearbyPlace = nearbyPlace
        self.backgroundColor = UIColor(named: "BackgroundColor")!
        self.layer.cornerRadius = 5
        
        
        ///setando o endereco
        let bairro = String(nearbyPlace.district)
        let rua = String(nearbyPlace.address)
        let numero = String(nearbyPlace.number)
        
        let newAddress = "\(rua), \(numero) - \(bairro)"
        self.labelEndereco.text = newAddress
        
        ///edicao da tag de tipos
        self.tagView.stilyze(categoria: nearbyPlace.type.localizedDescription)
        self.tagView.layer.cornerRadius = 3
        self.tagLabel.text = nearbyPlace.type.localizedDescription
        
        ///setando o nome do lugar
        labelTitulo.text = nearbyPlace.name
    }
    
    func clickCheck() {
        if checkButton.imageView?.image == UIImage(systemName: "circle"){
            checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
        else{
            checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        //delegate?.newLocation(nearbyPlace: self.nearbyPlace!)
    }
    func desative(){
        checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
    }
}
