//
//  SugestoesCollectionViewCell.swift
//  TheMidway
//
//  Created by Beatriz Duque on 14/12/21.
//

import UIKit
protocol SugestoesCollectionViewCellDelegate: AnyObject{
    func changeLocal(local: String)
}

class SugestoesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var setButton: UIButton!
    
    weak public var delegate: SugestoesCollectionViewCellDelegate?
    
    let images = ["Bakery", "Bar", "Cinema", "Coffee", "Restaurant", "Shopping", "Theater"]

    let names = ["Bakery", "Bar", "Cinema", "Coffee", "Restaurant", "Shopping", "Theater"]
    
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var labelNome: UILabel!
    
    func stylize(index: Int){
        imageBackground.image = UIImage(named: images[index])
        imageBackground.layer.cornerRadius = 8
        labelNome.text = names[index]
    }
    func didChange() {
        if setButton.imageView?.image == UIImage(systemName: "circle"){
            setButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
        else{
            setButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    func desativate(){
        setButton.setImage(UIImage(systemName: "circle"), for: .normal)
    }
}
